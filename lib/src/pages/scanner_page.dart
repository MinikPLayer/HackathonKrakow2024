import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/view/home_view.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.homeViewState});

  final HomeViewState homeViewState;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1)).then((d) {
      if (context.mounted) HomeView.showToast(context, 'Seat scanned successfully!');
      widget.homeViewState.pageController.animateToPage(
        1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seat scanner'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Scan your seat', style: Theme.of(context).textTheme.headlineLarge),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage('assets/images/qr_photo.jpg'),
            ),
          ),
        ],
      ),
    );
  }
}
