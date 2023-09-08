import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lindi_sticker_widget/draggable_widget.dart';
import 'dart:ui' as ui;

import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';

class LindiController extends ChangeNotifier {
  List<DraggableWidget> widgets = [];

  Color _borderColor = Colors.blue;
  Color _iconColor = Colors.white;

  set borderColor(Color color) {
    _borderColor = color;
    notifyListeners();
  }

  set iconColor(Color color) {
    _iconColor = color;
    notifyListeners();
  }

  addWidget(Widget widget) {
    Key key = Key('lindi-${DateTime.now().millisecondsSinceEpoch}-${_nrRnd()}');
    widgets.add(DraggableWidget(
        key: key,
        borderColor: _borderColor,
        iconColor: _iconColor,
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
    _border(key);
  }

  clearAllBorders() {
    _border(const Key('-1'));
  }

  _border(Key? key) {
    for (int i = 0; i < widgets.length; i++) {
      if (widgets[i].key == key) {
        widgets[i].update(true);
      } else {
        widgets[i].update(false);
      }
    }
    notifyListeners();
  }

  _delete(key) {
    widgets.removeWhere((element) {
      return element.key! == key;
    });
    notifyListeners();
  }

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

  Future<Uint8List?> saveAsUint8List() async {
    clearAllBorders();
    try {
      Uint8List? pngBytes;
      double pixelRatio = 2;
      await Future.delayed(const Duration(milliseconds: 700))
          .then((value) async {
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

  int _nrRnd() {
    Random rnd;
    int min = 1;
    int max = 100000;
    rnd = Random();
    return min + rnd.nextInt(max - min);
  }
}
