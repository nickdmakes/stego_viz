import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widget/image_select_card/image_select_card.dart';

class ImageSelectView extends StatelessWidget {
  const ImageSelectView({super.key});

  // Function that turns an asset image into a base64 byte string
  Future<String> _imageToBase64(String path) async {
    print("looking for image");
    final bytes = await rootBundle.load(path);
    print(bytes);
    return base64Encode(Uint8List.view(bytes.buffer));
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 10,
      itemBuilder: (context, index) {
        return FutureBuilder<String>(
          future: _imageToBase64('assets/images/image_placeholder.png'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ImageSelectCard(
                title: 'Image $index',
                image: snapshot.data,
                subtitle: 'Subtitle $index',
              );
            } else {
              return const CircularProgressIndicator();
            }
          },
        );
      }
    );
  }
}
