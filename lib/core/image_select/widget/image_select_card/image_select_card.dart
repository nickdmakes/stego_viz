import 'package:flutter/material.dart';
import 'package:stego_viz/imutils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';


class ImageSelectCard extends StatefulWidget {
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
  State<ImageSelectCard> createState() => _ImageSelectCardState();
}

class _ImageSelectCardState extends State<ImageSelectCard> with TickerProviderStateMixin {

  @override
  void initState() {
    slidableController = SlidableController(this);
    super.initState();
  }

  @override
  void dispose() {
    slidableController.dispose();
    super.dispose();
  }

  late final SlidableController slidableController;

  @override
  Widget build(BuildContext context) {
    // Slidable List Tile that can be swiped to reveal delete button
    return Slidable(
      // Specify a key if the Slidable is dismissible.
      controller: slidableController,
      // The start action pane is the one at the left or the top side.
      endActionPane: ActionPane(
        // A motion is a widget used to control how the pane animates.
        motion: const ScrollMotion(),
        extentRatio: 0.3,
        dragDismissible: false,
        // All actions are defined in the children parameter.
        children: [
          // A SlidableAction can have an icon and/or a label.
          SlidableAction(
            onPressed: (BuildContext _) {
              widget.onDelete?.call(context);
            },
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
            child: Image.memory(base64ToBytes(widget.imageString ?? "")),
          ),
          trailing: const Icon(Icons.chevron_right, color: Colors.grey),
          title: Text(widget.title ?? ""),
          subtitle: Text(
            widget.subtitle ?? "",
            style: const TextStyle(
              fontSize: 12.0,
            ),
          ),
          onTap: () => widget.onSelect?.call(),
        ),
      )
    );
  }
}
