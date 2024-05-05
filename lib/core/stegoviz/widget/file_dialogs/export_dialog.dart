import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stego_viz/imutils.dart';
import 'package:stego_viz/app/bloc/stego_session/stego_session_cubit.dart';


Future<T?> showExportDialog<T>({required BuildContext context}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      return const _ExportDialog();
    },
  );
}

class _ExportDialog extends StatefulWidget {
  const _ExportDialog();

  @override
  State<_ExportDialog> createState() => _ExportDialogState();
}

class _ExportDialogState extends State<_ExportDialog> {

  bool exportComplete = false;

  @override
  Widget build(BuildContext context) {
    final stegoSession = context.read<StegoSessionCubit>();

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.photo,
            size: 40,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          const Text("Export to Photos"),
        ],
      ),
      // rounded corners of 10px
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      insetPadding: const EdgeInsets.all(16),
      content: BlocBuilder<StegoSessionCubit, StegoSessionState>(
        buildWhen: (previous, current) => previous.status != current.status,
        builder: (context, state) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                exportComplete
                    ? const Center(
                      child: Text(
                        'Export Successful',
                        style: TextStyle(fontSize: 18.0, color: Colors.green),
                      ),
                    )
                    : Text(
                      'Export the current stego image to the Photos app?',
                      style: TextStyle(fontSize: 18.0, color: Theme.of(context).colorScheme.onSurface),
                    ),
                const SizedBox(height: 16),
                exportComplete ? const SizedBox(height: 0, width: 0) : Text(
                  'Size: ${prettifyImageSize(stegoSession.state.stegoImage)}',
                  style: TextStyle(fontSize: 16.0, color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
          );
        }
      ),
      actions: [
        BlocBuilder<StegoSessionCubit, StegoSessionState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return TextButton(
              onPressed: state.status == StegoSessionStatus.exporting
                ? null
                : () => Navigator.of(context).pop(),
              child: Text(
                exportComplete == true ? 'CLOSE' : 'CANCEL',
                style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 18.0,
                ),
              ),
            );
          }
        ),
        exportComplete ? const SizedBox(height: 0, width: 0) : BlocBuilder<StegoSessionCubit, StegoSessionState>(
          buildWhen: (previous, current) => previous.status != current.status,
          builder: (context, state) {
            return TextButton(
              onPressed: () async {
                await stegoSession.exportImageToLibrary();
                setState(() {
                  exportComplete = true;
                });
              },
              child: exportComplete == true
                  ? const SizedBox(width: 0, height: 0)
                  : state.status == StegoSessionStatus.exporting
                  ? const CircularProgressIndicator()
                  : Text('EXPORT', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 18.0, fontWeight: FontWeight.bold)),
            );
          }
        ),
      ],
    );
  }
}
