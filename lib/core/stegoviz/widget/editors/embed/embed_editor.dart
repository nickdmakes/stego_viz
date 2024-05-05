import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:stego_viz/shared/stegoviz_edu.dart';
import 'package:stegoviz_storage/stegoviz_storage.dart';

import 'package:stego_viz/app/bloc/stego_session/stego_session_cubit.dart';
import 'embed_edu_content.dart';

class EmbedEditor extends StatelessWidget {
  const EmbedEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 8, bottom: 16),
        child: BlocBuilder<StegoSessionCubit, StegoSessionState>(
          buildWhen: (previous, current) => previous.save.method != current.save.method,
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                _EmbedButton(
                  color: 'LSB Replacement',
                  isActive: state.save.method == StegoEmbeddingMethod.lsb,
                  onEmbedClicked: () {
                    if(state.save.method != StegoEmbeddingMethod.lsb) {
                      context.read<StegoSessionCubit>().updateEmbeddingMethod(StegoEmbeddingMethod.lsb);
                    }
                  },
                  onSettingsClicked: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const _EmbedSettingsDialog(
                          title: 'LSB Settings',
                          titleIcon: Icon(Icons.settings),
                          child: _LeastSignificantBitSettings(),
                        );
                      },
                    );
                  },
                  onHelpClicked: () {
                    showStegoVizEduDialog(
                      context: context,
                      title: 'LSB Replacement',
                      leading: Icon(
                        Icons.swap_horizontal_circle_outlined,
                        size: 40,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: const LsbEduContent(),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _EmbedButton(
                  color: 'Discrete Cosine Transform',
                  isActive: state.save.method == StegoEmbeddingMethod.dct,
                  onEmbedClicked: () {
                    if(state.save.method != StegoEmbeddingMethod.dct) {
                      context.read<StegoSessionCubit>().updateEmbeddingMethod(StegoEmbeddingMethod.dct);
                    }
                  },
                  onSettingsClicked: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const _EmbedSettingsDialog(
                          title: 'Discrete Cosine Transform',
                          titleIcon: Icon(Icons.settings),
                          child: SizedBox(),
                        );
                      },
                    );
                  },
                  onHelpClicked: () {
                    showStegoVizEduDialog(
                      context: context,
                      title: 'Discrete Cosine Transform Embed',
                      child: const SizedBox(),
                    );
                  },
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}

class _EmbedSettingsDialog extends StatelessWidget {
  const _EmbedSettingsDialog({
    required this.title,
    this.titleIcon,
    this.child,
  });
  
  final String title;
  final Icon? titleIcon;
  final Widget? child;
  

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        children: [
          titleIcon ?? const SizedBox(width: 0),
          titleIcon == null ? const SizedBox(width: 0) : const SizedBox(width: 8),
          Text(title),
        ],
      ),
      insetPadding: const EdgeInsets.all(16),
      content: SizedBox(
        width: MediaQuery.of(context).size.width - 10,
        child: child,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}

class _LeastSignificantBitSettings extends StatelessWidget {
  const _LeastSignificantBitSettings();

  @override
  Widget build(BuildContext context) {
    // Toggle button
    return BlocBuilder<StegoSessionCubit, StegoSessionState>(
      buildWhen: (previous, current) => previous.save.bitPlane != current.save.bitPlane,
      builder: (context, state) {
        return const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Embedding Bit Plane:', style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            _BitPlaneButtons(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("MSB", style: TextStyle(fontSize: 12)),
                  Text("LSB", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _BitPlaneButtons extends StatelessWidget {
  const _BitPlaneButtons();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<StegoSessionCubit, StegoSessionState>(
      builder: (context, state) {
        return Row(
          mainAxisSize: MainAxisSize.max,
          children: List.generate(
            8,
            (index) => _bitPlaneButton(
              context: context,
              bitPlane: 8 - index,
              isActive: state.save.bitPlane == index + 1,
              onPressed: () {
                context.read<StegoSessionCubit>().updateBitPlane(index + 1);
              },
            ),
          ),
        );
      },
    );
  }

  Widget _bitPlaneButton({
    required BuildContext context,
    required int bitPlane,
    required bool isActive,
    required Function() onPressed,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(
            gradient: isActive
                ? LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary.withAlpha(50),
                      Theme.of(context).colorScheme.secondary.withAlpha(20),
                    ],
                  )
                : null,
            border: Border.all(
              color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey.withAlpha(100),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(
              bitPlane.toString(),
              style: TextStyle(
                color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}



class _EmbedButton extends StatelessWidget {
  const _EmbedButton({
    required this.color,
    required this.isActive,
    required this.onEmbedClicked,
    required this.onSettingsClicked,
    required this.onHelpClicked,
  });

  final String color;
  final bool isActive;
  final Function() onEmbedClicked;
  final Function() onSettingsClicked;
  final Function() onHelpClicked;

  @override
  Widget build(BuildContext context) {
    // button is a large rectacgular container with gesture detection
    // The border of the container highlights to the dark theme purple color when the button is pressed
    return GestureDetector(
      onTap: onEmbedClicked,
      // add transparent gradient to the container
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 50),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: isActive
                      ? LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary.withAlpha(50),
                            Theme.of(context).colorScheme.secondary.withAlpha(20),
                          ],
                        )
                      : null,
                  border: Border.all(
                    color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey.withAlpha(100),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    color,
                    style: TextStyle(
                      color: isActive ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Gear icon button
            IconButton(
              icon: Icon(
                Icons.settings,
                color: Theme.of(context).colorScheme.primary.withAlpha(150),
              ),
              onPressed: onSettingsClicked,
            ),
            // question mark icon button
            IconButton(
              icon: Icon(
                Icons.help_outline,
                color: Theme.of(context).colorScheme.primary.withAlpha(150),
              ),
              onPressed: onHelpClicked,
            ),
          ],
        ),
      ),
    );
  }
}


