import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stego_viz/imutils.dart';

import 'package:stegoviz_storage/stegoviz_storage.dart';

import 'package:stego_viz/app/bloc/stego_session/stego_session_cubit.dart';


class ColorEditor extends StatelessWidget {
  const ColorEditor({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<StegoSessionCubit, StegoSessionState>(
          buildWhen: (previous, current) => previous.save.color != current.save.color,
          builder: (context, state) {
            return ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 150),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _ColorButton(
                      color: "Original",
                      isActive: state.save.color == StegoImageColor.rgb,
                      onPressed: () {
                        if (state.save.color != StegoImageColor.rgb) {
                          context.read<StegoSessionCubit>().updateColor(StegoImageColor.rgb);
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _ColorButton(
                      color: "Gray",
                      isActive: state.save.color == StegoImageColor.gray,
                      onPressed: () {
                        if (state.save.color != StegoImageColor.gray) {
                          context.read<StegoSessionCubit>().updateColor(StegoImageColor.gray);
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  const _ColorButton({
    required this.color,
    required this.isActive,
    required this.onPressed,
  });

  final String color;
  final bool isActive;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    // button is a large rectacgular container with gesture detection
    // The border of the container highlights to the dark theme purple color when the button is pressed
    return GestureDetector(
      onTap: onPressed,
      // add transparent gradient to the container
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive
              ? RadialGradient(
                  radius: 0.8,
                  colors: [
                    Theme.of(context).colorScheme.primary.withAlpha(20),
                    Theme.of(context).colorScheme.primary.withAlpha(50),
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
    );
  }
}

