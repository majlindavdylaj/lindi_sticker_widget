library lindi_sticker_widget;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';

class LindiStickerWidget extends StatefulWidget {

  static GlobalKey globalKey = GlobalKey();

  LindiController controller;
  Widget child;

  LindiStickerWidget({
    Key? key,
    required this.controller,
    required this.child
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _LindiStickerWidgetState();

}

class _LindiStickerWidgetState extends State<LindiStickerWidget> {

  @override
  void initState() {
    widget.controller.addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: LindiStickerWidget.globalKey,
      child: Stack(
        alignment: Alignment.center,
        children: [
          widget.child,
          Positioned.fill(
            child: Stack(
              children: [
                for(int i = 0; i < widget.controller.widgets.length; i++)
                  widget.controller.widgets[i]
              ],
            ),
          )
        ],
      ),
    );
  }
}

