import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class ImageSelectCard extends StatelessWidget {
  const ImageSelectCard({
    super.key,
    this.title,
    this.imageString,
    this.subtitle,
    this.onSelect,
    this.onDelete,
  });

  final String? title;
  // image in base64 byte string
  final String? imageString;
  final String? subtitle;
  final Function()? onSelect;
  final Function(BuildContext)? onDelete;

  @override
  Widget build(BuildContext context) {
    // Convert base64 byte string to image
    final imgBytes = base64Decode(imageString!);
    final img = Image.memory(imgBytes);

    // Slidable List Tile that can be swiped to reveal delete button
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      key: const ValueKey(0),

      // The start action pane is the one at the left or the top side.
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),

        // A pane can dismiss the Slidable.
        dismissible: DismissiblePane(onDismissed: () {
          // The dismissible pane can be dismissed by the user.
          onDelete?.call(context);
        }),

        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: onDelete,
            backgroundColor: const Color(0xFFFE4A49),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      // The child of the Slidable is what the user sees when the
      // component is not dragged.
      child: Card(
        // no rounded corners
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        // no margin
        margin: const EdgeInsets.all(0),
        child: ListTile(
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: img,
          ),
          title: Text(title ?? ""),
          subtitle: Text(subtitle ?? ""),
          onTap: () => onSelect ?? () {},
        ),
      )
    );
  }
}
