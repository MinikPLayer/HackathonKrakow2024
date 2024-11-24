import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/pages/connection_details_page.dart';
import 'package:hackathon_krakow_2024/src/providers/user_provider.dart';
import 'package:hackathon_krakow_2024/src/widgets/clock_widget.dart';
import 'package:intl/intl.dart';

class MyTicketsPage extends StatelessWidget {
  const MyTicketsPage({super.key, required this.userProvider});

  final UserProvider userProvider;

  @override
  Widget build(BuildContext context) {
    var tickets = userProvider.tickets;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My tickets'),
      ),
      body: Column(
        children: [
          const ClockWidget(),
          if (tickets.isEmpty)
            Expanded(
              child: Center(
                child: Text('No tickets found', style: Theme.of(context).textTheme.headlineLarge),
              ),
            ),
          if (tickets.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: userProvider.tickets.length,
                itemBuilder: (context, index) {
                  var ticket = tickets[index];
                  return ListenableBuilder(
                    listenable: ticket.connection,
                    builder: (context, child) => ListTile(
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ticket.connection.from.name),
                          Row(
                            children: [
                              if (ticket.connection.delay.inMinutes > 0)
                                Text('(+${ticket.connection.delay.inMinutes} min) ',
                                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red)),
                              Text(DateFormat.Hm().format(ticket.connection.departureTime)),
                            ],
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ticket.connection.to.name),
                          Text(DateFormat.Hm().format(ticket.connection.arrivalTime))
                        ],
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ConnectionDetailsPage(
                              connection: ticket.connection,
                              userProvider: userProvider,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
