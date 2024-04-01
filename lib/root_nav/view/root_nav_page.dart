import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/root_nav_cubit.dart';
import 'root_nav_view.dart';

class RootNavPage extends StatelessWidget {
  const RootNavPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const RootNavPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RootNavCubit(),
      child: RootNavView(),
    );
  }
}
