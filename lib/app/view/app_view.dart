import 'package:flutter/material.dart';

import 'package:stego_viz/core/image_select/image_select.dart';

import 'splash_page.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stego Viz',
      theme: ThemeData.dark(),
      navigatorKey: _navigatorKey,
      home: const ImageSelectPage(),
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
