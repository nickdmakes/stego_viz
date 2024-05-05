import 'package:flutter/material.dart';

class SecretMessageEduContent extends StatelessWidget {
  const SecretMessageEduContent({super.key});

  @override
  Widget build(BuildContext context) {

    const message = '''
    Use this field to enter the confidential message you wish to hide using steganography. The secret message will be concealed within your selected image, to ensure its confidentiality and security. 
    Be mindful that the content you input here will be encoded and hidden within the image, so ensure accuracy and discretion in your message.''';

    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          message,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
