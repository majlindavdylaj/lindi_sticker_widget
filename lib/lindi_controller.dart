import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lindi_sticker_widget/draggable_widget.dart';
import 'dart:ui' as ui;

import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';

import 'index_stream.dart';

/// A Dart class LindiController extending ChangeNotifier,
/// used for managing a list of draggable widgets and their properties.
///
class LindiController extends ChangeNotifier {
  /// List to store draggable widgets.
  ///
  List<DraggableWidget> widgets = [];

  /// Color of the border
  ///
  /// Defaults to Colors.blue
  ///
  Color borderColor;

  /// Color of the icons
  ///
  /// Defaults to Colors.white
  ///
  Color iconColor;

  /// Show the done button
  ///
  /// Defaults to true
  ///
  bool showDone;

  /// Show the close button
  ///
  /// Defaults to true
  ///
  bool showClose;

  /// Show the flip button
  ///
  /// Defaults to true
  ///
  bool showFlip;

  /// Show the stack button
  ///
  /// Defaults to true
  ///
  bool showStack;

  /// Show the lock button
  ///
  /// Defaults to true
  ///
  bool showLock;

  /// Show All Buttons and Border
  ///
  /// Defaults to true
  ///
  bool showAllBorders;

  /// Should the widget move
  ///
  /// Defaults to true
  ///
  bool shouldMove;

  /// Should the widget rotate
  ///
  /// Defaults to true
  ///
  bool shouldRotate;

  /// Should the widget scale
  ///
  /// Defaults to true
  ///
  bool shouldScale;

  /// Widget minimum scale
  ///
  /// Defaults 0.5
  ///
  double minScale;

  /// Widget maximum scale
  ///
  /// Defaults 4
  ///
  double maxScale;

  /// Stream to listen selected index
  ///
  IndexStream<int> selectedIndex = IndexStream<int>();

  /// Constructor to initialize properties with default values.
  ///
  LindiController(
      {this.borderColor = Colors.blue,
      this.iconColor = Colors.white,
      this.showDone = true,
      this.showClose = true,
      this.showFlip = true,
      this.showStack = true,
      this.showLock = true,
      this.showAllBorders = true,
      this.shouldMove = true,
      this.shouldRotate = true,
      this.shouldScale = true,
      this.minScale = 0.5,
      this.maxScale = 4});

  // Method to add a widget to the list of draggable widgets.
  addWidget(Widget widget) {
    // Generate a unique key for the widget.
    Key key = Key('lindi-${DateTime.now().millisecondsSinceEpoch}-${_nrRnd()}');

    // Create a DraggableWidget with specified properties.
    widgets.add(DraggableWidget(
        key: key,
        borderColor: borderColor,
        iconColor: iconColor,
        showDone: showDone,
        showClose: showClose,
        showFlip: showFlip,
        showStack: showStack,
        showLock: showLock,
        showAllBorders: showAllBorders,
        shouldMove: shouldMove,
        shouldRotate: shouldRotate,
        shouldScale: shouldScale,
        minScale: minScale,
        maxScale: maxScale,
        onBorder: (key) {
          _border(key);
        },
        onDelete: (key) {
          _delete(key);
        },
        onLayer: (key) {
          _layer(key);
        },
        child: widget));

    // Highlight the border of the added widget.
    _border(key);
  }

  // Method to clear borders of all widgets.
  clearAllBorders() {
    _border(const Key('-1'));
  }

  // Method to highlight the border of a specific widget.
  _border(Key? key) {
    for (int i = 0; i < widgets.length; i++) {
      if (widgets[i].key == key) {
        widgets[i].showBorder(true);
        if (selectedIndex.current != i) {
          selectedIndex.update(i);
        }
      } else {
        widgets[i].showBorder(false);
      }
    }
    notifyListeners();
  }

  // Method to delete a widget from the list.
  _delete(key) {
    widgets.removeWhere((element) {
      return element.key! == key;
    });
    notifyListeners();
  }

  // Method to change the layering of a widget.
  _layer(key) {
    DraggableWidget widget =
        widgets.firstWhere((element) => element.key == key);
    int index = widgets.indexOf(widget);
    if (index != 0) {
      widgets.remove(widget);
      widgets.insert(index - 1, widget);
      notifyListeners();
    }
  }

  // Method to save the widget layout as a Uint8List image.
  Future<Uint8List?> saveAsUint8List() async {
    // Clear all borders before capturing the image.
    clearAllBorders();
    try {
      Uint8List? pngBytes;
      double pixelRatio = 2;
      await Future.delayed(const Duration(milliseconds: 700))
          .then((value) async {
        // Capture the image of the widget.
        RenderRepaintBoundary boundary =
            LindiStickerWidget.globalKey.currentContext?.findRenderObject()
                as RenderRepaintBoundary;
        ui.Image image = await boundary.toImage(pixelRatio: pixelRatio);
        ByteData? byteData =
            await image.toByteData(format: ui.ImageByteFormat.png);
        pngBytes = byteData?.buffer.asUint8List();
      });
      return pngBytes;
    } catch (e) {
      rethrow;
    }
  }

  // Helper function to generate a random number.
  int _nrRnd() {
    Random rnd;
    int min = 1;
    int max = 100000;
    rnd = Random();
    return min + rnd.nextInt(max - min);
  }
}
