import 'package:flutter/material.dart';
import 'package:stego_viz/theme.dart';

import 'package:stego_viz/root_nav/root_nav.dart';

import 'splash_page.dart';

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stego Viz',
      theme: theme,
      navigatorKey: _navigatorKey,
      home: const RootNavPage(),
      onGenerateRoute: (_) => SplashPage.route(),
    );
  }
}
