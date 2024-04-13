import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stegoviz_storage/stegoviz_storage.dart';

import '../bloc/stego_session/stego_session_cubit.dart';
import 'app_view.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => StegoVizStorage(),
      child: BlocProvider(
        create: (context) => StegoSessionCubit(stegovizStorage: context.read<StegoVizStorage>()),
        child: const AppView(),
      ),
    );
  }
}
