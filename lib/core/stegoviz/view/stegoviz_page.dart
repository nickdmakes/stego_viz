import 'package:flutter/material.dart';

import 'stegoviz_view.dart';

class StegoVizPage extends StatelessWidget {
  const StegoVizPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const StegoVizPage());
  }

  @override
  Widget build(BuildContext context) {
    return const StegoVizView();
  }
}
