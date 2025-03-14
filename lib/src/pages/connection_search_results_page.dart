import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/models/station.dart';
import 'package:hackathon_krakow_2024/src/models/ticket.dart';
import 'package:hackathon_krakow_2024/src/pages/connection_details_page.dart';
import 'package:hackathon_krakow_2024/src/providers/connections_provider.dart';
import 'package:hackathon_krakow_2024/src/providers/user_provider.dart';
import 'package:intl/intl.dart';

class ConnectionSearchResultsPage extends StatefulWidget {
  const ConnectionSearchResultsPage({
    super.key,
    required this.from,
    required this.to,
    required this.conProvider,
    this.departureTime,
    this.arrivalTime,
    required this.userProvider,
  });

  final Station from;
  final Station to;
  final DateTime? departureTime;
  final DateTime? arrivalTime;
  final ConnectionsProvider conProvider;
  final UserProvider userProvider;

  @override
  State<ConnectionSearchResultsPage> createState() => _ConnectionSearchResultsPageState();
}

class _ConnectionSearchResultsPageState extends State<ConnectionSearchResultsPage> {
  int currentLimit = 10;

  @override
  Widget build(BuildContext context) {
    var (filteredConnections, isAll) = widget.conProvider
        .getConnections(widget.from, widget.to, widget.departureTime, widget.arrivalTime, currentLimit);
    var generateCount = isAll ? filteredConnections.length : filteredConnections.length + 1;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search result'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('From:', style: Theme.of(context).textTheme.headlineMedium),
                  Text(widget.from.name, style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('To:', style: Theme.of(context).textTheme.headlineMedium),
                  Text(widget.to.name, style: Theme.of(context).textTheme.headlineMedium),
                ],
              ),
            ),
            if (widget.departureTime != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Departure:', style: Theme.of(context).textTheme.headlineSmall),
                    Text(
                        '${DateFormat.yMMMd().format(widget.departureTime!)} ${DateFormat.Hm().format(widget.departureTime!)}',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
            if (widget.arrivalTime != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Arrival:', style: Theme.of(context).textTheme.headlineSmall),
                    Text(
                        '${DateFormat.yMMMd().format(widget.arrivalTime!)} ${DateFormat.Hm().format(widget.arrivalTime!)}',
                        style: Theme.of(context).textTheme.headlineSmall),
                  ],
                ),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: generateCount,
                itemBuilder: (context, index) {
                  if (!isAll && index == filteredConnections.length) {
                    return ListTile(
                      title: const Center(child: Text('Load more')),
                      onTap: () {
                        setState(() {
                          currentLimit += 10;
                        });
                      },
                    );
                  }

                  return Column(
                    children: [
                      ListTile(
                        leading: Icon(filteredConnections[index].icon),
                        trailing: Text('${filteredConnections[index].price} PLN',
                            style: Theme.of(context).textTheme.headlineSmall),
                        title: Row(
                          children: [
                            Text(
                                '${DateFormat.Hm().format(filteredConnections[index].departureTime)} - ${DateFormat.Hm().format(filteredConnections[index].arrivalTime)}',
                                style: Theme.of(context).textTheme.headlineSmall),
                            if (filteredConnections[index].delay.inMinutes > 0)
                              Text(' (+${filteredConnections[index].delay.inMinutes} min)',
                                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.red)),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(DateFormat.yMMMd().format(filteredConnections[index].departureTime)),
                          ],
                        ),
                        onTap: () async {
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ConnectionDetailsPage(
                                connection: filteredConnections[index],
                                userProvider: widget.userProvider,
                              ),
                            ),
                          );
                        },
                      ),
                      const Divider(
                        indent: 15,
                        endIndent: 15,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
