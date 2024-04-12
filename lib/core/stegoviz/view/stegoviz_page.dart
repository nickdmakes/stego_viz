import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stego_viz/root_nav/root_nav.dart';

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
