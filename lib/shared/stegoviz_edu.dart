import 'package:flutter/material.dart';


Future<T?> showStegoVizEduDialog<T>({
  required BuildContext context,
  required String title,
  Widget? leading,
  required Widget child,
}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return StegoVizEduDialog(
        title: title,
        leading: leading,
        child: child,
      );
    },
  );
}

class StegoVizEduDialog extends StatelessWidget {
  const StegoVizEduDialog({
    super.key,
    required this.title,
    this.leading,
    this.child,
  });

  final String title;
  final Widget? leading;
  final Widget? child;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: leading != null
          ? Row(
              children: [
                leading!,
                const SizedBox(width: 8),
                Text(title),
              ],
            )
          : Text(title),
      // rounded corners of 10px
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      insetPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: child,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('close'),
        ),
      ],
    );
  }
}
