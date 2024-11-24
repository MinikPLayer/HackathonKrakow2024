import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/pages/landing_page.dart';
import 'package:hackathon_krakow_2024/src/pages/my_tickets_page.dart';
import 'package:hackathon_krakow_2024/src/providers/connections_provider.dart';
import 'package:hackathon_krakow_2024/src/providers/user_provider.dart';
import 'package:hackathon_krakow_2024/src/settings/settings_controller.dart';
import 'package:hackathon_krakow_2024/src/settings/settings_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.settingsController,
    required this.connectionsProvider,
    required this.userProvider,
  });

  static const routeName = '/home';

  final SettingsController settingsController;
  final ConnectionsProvider connectionsProvider;
  final UserProvider userProvider;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class SubRouteEntry {
  final String title;
  final String subRoute;
  final IconData icon;

  SubRouteEntry(this.title, this.subRoute, this.icon);
}

class _HomeViewState extends State<HomeView> {
  final navigatorKey = GlobalKey<NavigatorState>();
  static List<SubRouteEntry> subRoutes = [
    SubRouteEntry('Home', 'landing', Icons.home),
    SubRouteEntry('My Tickets', 'tickets', Icons.airplane_ticket),
    SubRouteEntry('Settings', 'settings', Icons.settings),
  ];

  final pageController = PageController();

  int currentSubpageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.settingsController,
      builder: (BuildContext context, Widget? child) {
        return ListenableBuilder(
          listenable: widget.connectionsProvider,
          builder: (BuildContext context, Widget? child) => PopScope(
            child: Scaffold(
              bottomNavigationBar: BottomNavigationBar(
                currentIndex: currentSubpageIndex,
                onTap: (value) => setState(() {
                  pageController.animateToPage(
                    value,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }),
                items: subRoutes
                    .map((e) => BottomNavigationBarItem(
                          icon: Icon(e.icon),
                          label: e.title,
                        ))
                    .toList(),
              ),
              body: PageView(
                controller: pageController,
                onPageChanged: (value) => setState(() {
                  currentSubpageIndex = value;
                }),
                children: [
                  LandingPage(
                    connectionsProvider: widget.connectionsProvider,
                    userProvider: widget.userProvider,
                  ),
                  MyTicketsPage(userProvider: widget.userProvider),
                  SettingsView(controller: widget.settingsController)
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
