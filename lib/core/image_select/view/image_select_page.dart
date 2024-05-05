import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stego_viz/core/stegoviz/stegoviz.dart';

import 'package:stegoviz_storage/stegoviz_storage.dart';

import 'package:stego_viz/app/bloc/stego_session/stego_session_cubit.dart';
import 'package:stego_viz/core/image_select/cubit/image_select_cubit.dart';

import 'image_select_view.dart';

class ImageSelectPage extends StatelessWidget {
  const ImageSelectPage({super.key});

  static Route route() {
    return MaterialPageRoute<void>(builder: (_) => const ImageSelectPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Select'),
      ),
      bottomNavigationBar: BottomAppBar(
        // default color for bottom app bar
        notchMargin: 14.0,
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.read<StegoSessionCubit>().clearSession();
          Navigator.push(context, StegoVizPage.route());
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: BlocProvider(
        create: (context) => ImageSelectCubit(stegoVizStorage: context.read<StegoVizStorage>()),
        child: const ImageSelectView(),
      ),
    );
  }
}
