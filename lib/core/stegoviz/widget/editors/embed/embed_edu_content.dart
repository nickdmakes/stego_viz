import 'package:flutter/material.dart';

class LsbEduContent extends StatelessWidget {
  const LsbEduContent({super.key});

  @override
  Widget build(BuildContext context) {

    const message = '''
    In LSB replacement, the least significant bit of the pixel values in your image is replaced with bits representing the secret message. 
    Since the least significant bit typically has the least impact on the overall value of a byte, these alterations are often imperceptible to the human eye''';

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          message,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 16),
        // Rich Text with an icon inline
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Tap the ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              WidgetSpan(
                child: Icon(
                  // settings icon
                  Icons.settings,
                  size: 22,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              TextSpan(
                text: ' icon to adjust the the bit plane used for embedding.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
