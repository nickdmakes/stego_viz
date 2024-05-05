import 'package:flutter/material.dart';

import 'statistics_view.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const StatisticsPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Statistics'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 28.0, color: Colors.grey),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: const StatisticsView(),
    );
  }
}
