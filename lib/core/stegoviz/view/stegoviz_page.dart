import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stego_viz/app/bloc/stego_session/stego_session_cubit.dart';
import 'package:stego_viz/core/stegoviz/widget/image_viewer/bloc/image_viewer_bloc.dart';
import 'package:stego_viz/root_nav/root_nav.dart';
import 'package:stego_viz/core/stegoviz/widget/file_dialogs/save_dialog.dart';
import 'package:stego_viz/core/stegoviz/widget/file_dialogs/export_dialog.dart';
import 'package:stego_viz/core/statistics/statistics.dart';

import 'stegoviz_view.dart';

class StegoVizPage extends StatelessWidget {
  const StegoVizPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const StegoVizPage());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RootNavCubit(),
      child: BlocListener<RootNavCubit, RootNavState>(
        listener: (context, state) {
          if (state.navIndex == 3) {
            context.read<RootNavCubit>().navIndexChanged(0);
            Navigator.of(context).push(StatisticsPage.route());
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Text('StegoViz'),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            // icon button on left side of app bar
            leading: IconButton(
              icon: const Icon(Icons.home_outlined, size: 28.0, color: Colors.grey),
              onPressed: () {
                context.read<StegoSessionCubit>().clearSession();
                Navigator.of(context).pop();
              },
            ),
            // text button on right side of app bar that says save
            actions: <Widget>[
              BlocBuilder<StegoSessionCubit, StegoSessionState>(
                buildWhen: (previous, current) => previous.stegoImage != current.stegoImage,
                builder: (context, state) {
                  return TextButton(
                    onPressed: state.stegoImage.isEmpty ? null : () {
                      showSaveDialog(context: context);
                    },
                    child: Text(
                      'Save',
                      style: TextStyle(
                        color: state.stegoImage.isEmpty ? Colors.grey : Theme.of(context).colorScheme.primary,
                        fontSize: 18.0,
                      ),
                    ),
                  );
                }
              ),
              BlocBuilder<StegoSessionCubit, StegoSessionState>(
                buildWhen: (previous, current) => previous.stegoImage != current.stegoImage,
                builder: (context, state) {
                  return IconButton(
                    onPressed: state.stegoImage.isEmpty ? null : () {
                      showExportDialog(context: context);
                    },
                    icon: Icon(
                      Icons.ios_share,
                      size: 28.0,
                      color: state.stegoImage.isEmpty ? Colors.grey : Theme.of(context).colorScheme.primary,
                    ),
                  );
                }
              ),
              const SizedBox(width: 10.0),
            ],
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          bottomNavigationBar: BlocBuilder<RootNavCubit, RootNavState>(
            builder: (context, state) {
              return RootNavBar(
                currentIndex: state.navIndex,
                onTabPressed: (int index) {
                  context.read<RootNavCubit>().navIndexChanged(index);
                },
              );
            }
          ),
          body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: BlocProvider(
              create: (_) => ImageViewerBloc(),
              child: const StegoVizView(),
            ),
          ),
        ),
      ),
    );
  }
}
