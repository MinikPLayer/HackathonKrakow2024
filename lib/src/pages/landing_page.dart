import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/providers/connections_provider.dart';
import 'package:hackathon_krakow_2024/src/widgets/search_connections_widget.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key, required this.connectionsProvider});

  static const String routeName = '/landing';
  final ConnectionsProvider connectionsProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchConnectionsWidget(connectionsProvider: connectionsProvider),
      ],
    );
  }
}
