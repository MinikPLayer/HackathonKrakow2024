import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:hackathon_krakow_2024/src/models/station.dart';
import 'package:hackathon_krakow_2024/src/pages/connection_search_results_page.dart';
import 'package:hackathon_krakow_2024/src/providers/connections_provider.dart';
import 'package:hackathon_krakow_2024/src/providers/user_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dp;

class SearchConnectionsWidget extends StatefulWidget {
  const SearchConnectionsWidget({super.key, required this.connectionsProvider, required this.userProvider});

  final ConnectionsProvider connectionsProvider;
  final UserProvider userProvider;

  @override
  State<SearchConnectionsWidget> createState() => _SearchConnectionsWidgetState();
}

class _SearchConnectionsWidgetState extends State<SearchConnectionsWidget> {
  final SearchController _startStationSearchController = SearchController();
  final SearchController _endStationSearchController = SearchController();

  DateTime _selectedDepartureArrivalTime = DateTime.now();
  bool _isDeparture = true;

  Widget generateStationSearchBox(SearchController controller, String hintText, IconData icon) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SearchAnchor(
              searchController: controller,
              builder: (context, controller) => SearchBar(
                    padding: const WidgetStatePropertyAll<EdgeInsets>(EdgeInsets.symmetric(horizontal: 16.0)),
                    hintText: hintText,
                    leading: Icon(icon),
                    controller: controller,
                    onTap: () {
                      controller.openView();
                    },
                    onChanged: (_) {
                      controller.openView();
                    },
                  ),
              suggestionsBuilder: (context, controller) {
                var query = controller.text;
                var resultStations = widget.connectionsProvider.stations
                    .where((element) => element.name.toLowerCase().contains(query.toLowerCase()))
                    .toList();

                return List.generate(resultStations.length, (index) {
                  final item = resultStations[index];
                  var icon =
                      item.type == StationType.train ? Icons.directions_railway_filled_outlined : Icons.directions_bus;
                  return ListTile(
                    leading: Icon(icon),
                    title: Text(item.name),
                    onTap: () {
                      controller.closeView(item.name);
                    },
                  );
                });
              }),
        ],
      ),
    );
  }

  Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }

  Future showTimeEditDialog() async {
    const timeEditTypes = ['Departure', 'Arrival'];
    final GroupButtonController timeTypeController = GroupButtonController(selectedIndex: _isDeparture ? 0 : 1);
    var currentDateTime = _selectedDepartureArrivalTime;

    return await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Edit time', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 32.0),
              GroupButton(
                options: GroupButtonOptions(
                  unselectedTextStyle: Theme.of(context).textTheme.bodyMedium,
                  spacing: 0,
                ),
                buttons: timeEditTypes,
                controller: timeTypeController,
                buttonIndexedBuilder: (selected, index, context) => Container(
                  width: 125,
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: selected
                        ? Theme.of(context).buttonTheme.colorScheme!.primaryContainer
                        : Theme.of(context).colorScheme.surfaceContainerHigh,
                    borderRadius: index == 0
                        ? const BorderRadius.horizontal(left: Radius.circular(8.0))
                        : index == timeEditTypes.length - 1
                            ? const BorderRadius.horizontal(right: Radius.circular(8.0))
                            : null,
                  ),
                  child: Center(child: Text(timeEditTypes[index])),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 250,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Ink(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: Theme.of(context).colorScheme.surfaceContainerHigh,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                '${DateFormat.yMMMMd().format(currentDateTime)} ${DateFormat.Hm().format(currentDateTime)}'),
                            const SizedBox(width: 8.0),
                            const Icon(Icons.edit),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      await dp.DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        theme: dp.DatePickerTheme(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          itemStyle: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
                          doneStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                          cancelStyle: TextStyle(color: Theme.of(context).colorScheme.secondary),
                        ),
                        minTime: DateTime.now().add(const Duration(days: -30)),
                        maxTime: DateTime.now().add(const Duration(days: 365)),
                        currentTime: currentDateTime,
                        onConfirm: (time) {
                          setDialogState(() {
                            currentDateTime = time;
                          });
                        },
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              ElevatedButton(
                onPressed: () {
                  setDialogState(() {
                    currentDateTime = DateTime.now();
                  });
                },
                child: const Text('Change to now'),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isDeparture = timeTypeController.selectedIndex == 0;
                  _selectedDepartureArrivalTime = currentDateTime;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Search connections',
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                          generateStationSearchBox(_startStationSearchController, 'Start station', Icons.play_arrow),
                          generateStationSearchBox(_endStationSearchController, 'End station', Icons.flag),
                        ],
                      ),
                    ),
                    const VerticalDivider(),
                    Expanded(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.0),
                              child: const Icon(
                                Icons.keyboard_arrow_right,
                                size: 48,
                              ),
                              onTap: () {
                                Station from;
                                Station to;
                                try {
                                  from = widget.connectionsProvider.stations
                                      .firstWhere((element) => element.name == _startStationSearchController.text);
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text('Start station not selected.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }

                                try {
                                  to = widget.connectionsProvider.stations
                                      .firstWhere((element) => element.name == _endStationSearchController.text);
                                } catch (e) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text('End station not selected.'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(ctx).pop();
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                  return;
                                }

                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return ConnectionSearchResultsPage(
                                    from: from,
                                    to: to,
                                    conProvider: widget.connectionsProvider,
                                    arrivalTime: _isDeparture ? null : _selectedDepartureArrivalTime,
                                    departureTime: _isDeparture ? _selectedDepartureArrivalTime : null,
                                    userProvider: widget.userProvider,
                                  );
                                }));
                              },
                            ),
                          ),
                          Expanded(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: [
                                    const Icon(Icons.watch_later_rounded),
                                    Text(DateFormat.Hm().format(_selectedDepartureArrivalTime)),
                                    Text(DateFormat.MMMd().format(_selectedDepartureArrivalTime)),
                                    Text(DateFormat.y().format(_selectedDepartureArrivalTime)),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                await showTimeEditDialog();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
