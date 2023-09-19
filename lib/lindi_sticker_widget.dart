library lindi_sticker_widget;

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';

/// A Flutter widget class LindiStickerWidget, which is used to display draggable stickers.
///
//ignore: must_be_immutable
class LindiStickerWidget extends StatefulWidget {
  /// A global key used to access this widget's state from outside.
  ///
  static GlobalKey globalKey = GlobalKey();

  /// The controller responsible for managing stickers and their behavior.
  ///
  LindiController controller;

  /// The [child] widget (the main content) to be displayed on the sticker.
  ///
  Widget child;

  /// Constructor to initialize the widget with a controller and a child widget.
  ///
  LindiStickerWidget({Key? key, required this.controller, required this.child})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _LindiStickerWidgetState();
}

class _LindiStickerWidgetState extends State<LindiStickerWidget> {
  @override
  void initState() {
    // Add a listener to the controller to update the widget when the controller changes.
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // A RepaintBoundary widget used to isolate and capture the sticker and its contents as an image.
    return RepaintBoundary(
      key: LindiStickerWidget.globalKey,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // The main child widget (content) displayed on the sticker.
          widget.child,
          // A positioned.fill Stack to overlay draggable widgets on top of the main content.
          Positioned.fill(
            child: Stack(
              children: [
                // Create draggable widgets from the controller's list and add them to the stack.
                for (int i = 0; i < widget.controller.widgets.length; i++)
                  widget.controller.widgets[i]
              ],
            ),
          )
        ],
      ),
    );
  }
}
