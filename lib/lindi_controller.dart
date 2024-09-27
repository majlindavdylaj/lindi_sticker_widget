import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lindi_sticker_widget/draggable_widget.dart';
import 'package:lindi_sticker_widget/lindi_sticker_icon.dart';
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

  /// List to store icons.
  ///
  List<LindiStickerIcon> icons;

  /// Color of the border
  ///
  /// Defaults to Colors.blue
  ///
  Color borderColor;

  /// Width of the border
  ///
  /// Defaults to 1.5
  ///
  double borderWidth;

  /// Show All Buttons and Border
  ///
  /// Defaults to true
  ///
  bool showBorders;

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

  /// Widget inside padding
  ///
  /// Defaults 13
  ///
  double insidePadding;

  /// Stream to listen selected index
  ///
  final IndexStream<int> _selectedIndex = IndexStream<int>();
  int _currentIndex = -1;

  bool deleted = false;

  /// Constructor to initialize properties with default values.
  ///
  LindiController(
      {required this.icons,
      this.borderColor = Colors.white,
      this.borderWidth = 1.5,
      this.showBorders = true,
      this.shouldMove = true,
      this.shouldRotate = true,
      this.shouldScale = true,
      this.minScale = 0.5,
      this.maxScale = 4,
      this.insidePadding = 13});

  // Method to add a widget to the list of draggable widgets.
  add(Widget widget) {
    // Generate a unique key for the widget.
    Key key = Key('lindi-${DateTime.now().millisecondsSinceEpoch}-${_nrRnd()}');

    // Create a DraggableWidget with specified properties.
    widgets.add(DraggableWidget(
        key: key,
        icons: icons,
        borderColor: borderColor,
        borderWidth: borderWidth,
        showBorders: showBorders,
        shouldMove: shouldMove,
        shouldRotate: shouldRotate,
        shouldScale: shouldScale,
        minScale: minScale,
        maxScale: maxScale,
        insidePadding: insidePadding,
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

  // Adds all the widgets from the given list
  addAll(List<Widget> widgets) {
    for (int i = 0; i < widgets.length; i++) {
      add(widgets[i]);
    }
  }

  // Sets up a listener for changes in the selected widget's position.
  // The provided callback function `stream` will be called whenever the position changes.
  onPositionChange(Function(int) stream) {
    _selectedIndex.stream.listen((int index) {
      _currentIndex = index;
      stream(_currentIndex);
    });
  }

  // Returns the currently selected widget based on the _currentIndex.
  // If the _currentIndex is within the valid range, the corresponding widget is returned.
  // Otherwise, it returns null.
  DraggableWidget? get selectedWidget {
    if (_currentIndex >= 0 && _currentIndex < widgets.length) {
      return widgets[_currentIndex];
    }
    return null;
  }

  // Method to clear borders of all widgets.
  clearAllBorders() {
    _border(const Key('-1'));
  }

  close() {
    _selectedIndex.close();
  }

  // Method to highlight the border of a specific widget.
  _border(Key? key) {
    for (int i = 0; i < widgets.length; i++) {
      if (widgets[i].key == key) {
        widgets[i].showBorder(true);
        if (_selectedIndex.current == null ||
            deleted ||
            widgets[_selectedIndex.current!].key != widgets[i].key) {
          if (deleted) deleted = false;
          _selectedIndex.update(i);
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
    deleted = true;
    //If widget is deleted, selected index is -1
    _selectedIndex.update(-1);
    notifyListeners();
  }

  // Method to change the layering of a widget.
  _layer(key) {
    int index =
        widgets.indexOf(widgets.firstWhere((element) => element.key == key));
    if (index > 0) {
      DraggableWidget item = widgets.removeAt(index);
      _currentIndex = index - 1;
      _selectedIndex.update(_currentIndex);
      widgets.insert(_currentIndex, item);
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
