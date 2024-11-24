import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/dialogs/add_connection_notification_dialog.dart';
import 'package:hackathon_krakow_2024/src/dialogs/report_problem_dialog.dart';
import 'package:hackathon_krakow_2024/src/models/connection.dart';
import 'package:hackathon_krakow_2024/src/models/reported_problem.dart';
import 'package:hackathon_krakow_2024/src/models/ticket.dart';
import 'package:hackathon_krakow_2024/src/providers/user_provider.dart';
import 'package:hackathon_krakow_2024/src/widgets/carriage_widget.dart';
import 'package:intl/intl.dart';

class ConnectionDetailsPage extends StatefulWidget {
  const ConnectionDetailsPage({super.key, required this.connection, required this.userProvider});

  final Connection connection;
  final UserProvider userProvider;

  @override
  State<ConnectionDetailsPage> createState() => _ConnectionDetailsPageState();
}

class _ConnectionDetailsPageState extends State<ConnectionDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var isAlreadyBought = widget.userProvider.tickets.any((element) => element.connection == widget.connection);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Connection details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notification_add),
            onPressed: () => showDialog(
              context: context,
              builder: (ctx) => AddConnectionNotificationDialog(
                connection: widget.connection,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ListTile(
                    leading: Icon(widget.connection.icon),
                    titleTextStyle: Theme.of(context).textTheme.labelLarge!,
                    subtitleTextStyle: Theme.of(context).textTheme.bodyMedium!,
                    title: Text(widget.connection.from.name),
                    subtitle: Text(
                      '${DateFormat.yMMMd().format(widget.connection.departureTime)} ${DateFormat.Hm().format(widget.connection.departureTime)}',
                    ),
                  ),
                ),
                if (widget.connection.delay.inMinutes > 0)
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          '+${widget.connection.delay.inMinutes}',
                          style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                Expanded(
                  child: ListTile(
                    trailing: Icon(widget.connection.icon),
                    titleTextStyle: Theme.of(context).textTheme.labelLarge!,
                    subtitleTextStyle: Theme.of(context).textTheme.bodyMedium!,
                    title: Text(
                      widget.connection.to.name,
                      textAlign: TextAlign.right,
                    ),
                    subtitle: Text(
                        '${DateFormat.yMMMd().format(widget.connection.arrivalTime)} ${DateFormat.Hm().format(widget.connection.arrivalTime)}',
                        textAlign: TextAlign.right),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.android),
                const SizedBox(width: 8),
                Text('AI prediction: ', style: Theme.of(context).textTheme.headlineSmall),
                Text(
                    '${widget.connection.avgDelay.inMinutes + (((widget.connection.delay.inMinutes - widget.connection.avgDelay.inMinutes) / 2).round())} min',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.red)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                const Icon(Icons.calendar_month),
                const SizedBox(width: 8),
                Text('7d average delay: ', style: Theme.of(context).textTheme.headlineSmall),
                Text('${widget.connection.avgDelay.inMinutes} min',
                    style: Theme.of(context).textTheme.headlineSmall!.copyWith(color: Colors.red)),
              ],
            ),
          ),
          if (widget.connection.problems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Text('User reported problems: ', style: Theme.of(context).textTheme.headlineSmall),
                ],
              ),
            ),
          ListenableBuilder(
            listenable: widget.connection,
            builder: (context, child) => ListView.builder(
              shrinkWrap: true,
              itemCount: widget.connection.problems.length,
              itemBuilder: (context, index) => ListTile(
                title: Text(
                  ReportedProblem.problemToString(widget.connection.problems[index].problem),
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: ReportedProblem.severityToColor(widget.connection.problems[index].severity)),
                ),
                leading: Icon(
                  ReportedProblem.severityToIcon(widget.connection.problems[index].severity),
                  color: ReportedProblem.severityToColor(widget.connection.problems[index].severity),
                ),
              ),
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Carriages:', style: Theme.of(context).textTheme.headlineSmall),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.connection.carriages.length,
              itemBuilder: (context, index) {
                var carriage = widget.connection.carriages[index];
                return CarriageWidget(carriage: carriage);
              },
            ),
          ),
          const Divider(
            height: 1,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                child: InkWell(
                  onTap: isAlreadyBought
                      ? () => showDialog(
                            context: context,
                            builder: (ctx) => ReportProblemDialog(
                              connection: widget.connection,
                            ),
                          )
                      : () async {
                          setState(() {
                            var newTicket = Ticket(connection: widget.connection);
                            widget.userProvider.addTicket(newTicket);
                          });
                          await showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text('Ticket bought'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      '${DateFormat.yMMMd().format(widget.connection.departureTime)} ${DateFormat.Hm().format(widget.connection.departureTime)}',
                                      style: Theme.of(context).textTheme.headlineSmall),
                                  Text('${widget.connection.price} PLN',
                                      style: Theme.of(context).textTheme.headlineSmall),
                                ],
                              ),
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
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: !isAlreadyBought
                          ? Text('Buy ticket for ${widget.connection.price} PLN')
                          : const Text('Report a problem'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
