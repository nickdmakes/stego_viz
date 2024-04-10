import 'package:flutter/material.dart';

import 'package:stego_viz/root_nav/root_nav.dart';

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
        shape: const CircularNotchedRectangle(),
        child: Container(
          height: 50.0,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, RootNavPage.route()),
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: const ImageSelectView(),
    );
  }
}
