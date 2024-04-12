import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stegoviz_storage/stegoviz_storage.dart';

import 'app_view.dart';

class AppPage extends StatelessWidget {
  const AppPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => StegoVizStorage(),
      child: const AppView(),
    );
  }
}
