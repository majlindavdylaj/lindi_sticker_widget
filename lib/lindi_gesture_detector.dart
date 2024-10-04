import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';

/// Define a callback type for LindiGestureDetector updates.
///
typedef LindiGestureDetectorCallback = void Function(
    double scale, Matrix4 matrix);

/// LindiGestureDetector for handling scaling, rotating, and translating the widget.
///
class LindiGestureDetector extends StatefulWidget {
  /// Callback function for when updates occur.
  ///
  final LindiGestureDetectorCallback onUpdate;

  /// [child] widget wrapped by the gesture detector.
  ///
  final Widget child;

  final GlobalKey centerKey;

  /// Control flags for various gesture types (translate, scale, rotate).
  ///
  /// Defaults to true
  ///
  final bool shouldTranslate;
  final bool shouldScale;
  final bool shouldRotate;

  /// Flag to clip the child widget.
  ///
  /// Defaults to true
  ///
  final bool clipChild;

  /// Behavior when handling hit tests.
  ///
  /// Defaults to HitTestBehavior.deferToChild
  ///
  final HitTestBehavior behavior;

  /// Callback functions for scale start and end.
  ///
  final Function(bool) onScaleStart;
  final VoidCallback onScaleEnd;

  /// Minimum and maximum scale values.
  ///
  final double minScale;
  final double maxScale;

  const LindiGestureDetector(
      {super.key,
      required this.centerKey,
      required this.onUpdate,
      required this.child,
      this.shouldTranslate = true,
      this.shouldScale = true,
      this.shouldRotate = true,
      this.clipChild = true,
      this.behavior = HitTestBehavior.deferToChild,
      required this.onScaleStart,
      required this.onScaleEnd,
      required this.minScale,
      required this.maxScale});

  @override
  State<LindiGestureDetector> createState() => LindiGestureDetectorState();
}

class LindiGestureDetectorState extends State<LindiGestureDetector> {
  // Matrices for handling translation, scaling, and rotation.
  Matrix4 translationDeltaMatrix = Matrix4.identity();
  Matrix4 scaleDeltaMatrix = Matrix4.identity();
  Matrix4 rotationDeltaMatrix = Matrix4.identity();
  Matrix4 matrix = Matrix4.identity();

  // Current and previous scale values.
  double recordScale = 1;
  double recordOldScale = 0;

  double initialRotation = 0;
  Offset initialFocalPoint = Offset.zero;
  Offset widgetCenter = Offset.zero;
  double initialDistance = 0;

  Offset centerOffset = Offset.zero;

  @override
  Widget build(BuildContext context) {
    // Wrap the child widget in a ClipRect if clipping is enabled.
    Widget child =
        widget.clipChild ? ClipRect(child: widget.child) : widget.child;

    // Create a GestureDetector to handle gestures.
    return GestureDetector(
      behavior: widget.behavior,
      onScaleStart: onDragStart,
      onScaleUpdate: onDragUpdate,
      onScaleEnd: onDragEnd,
      child: child,
    );
  }

  // ValueUpdater instances to track translation, scale, and rotation changes.
  ValueUpdater<Offset> translationUpdater = ValueUpdater(
    value: Offset.zero,
    onUpdate: (oldVal, newVal) => newVal - oldVal,
  );
  ValueUpdater<double> scaleUpdater = ValueUpdater(
    value: 1.0,
    onUpdate: (oldVal, newVal) => newVal / oldVal,
  );
  ValueUpdater<double> rotationUpdater = ValueUpdater(
    value: 0.0,
    onUpdate: (oldVal, newVal) => newVal - oldVal,
  );

  // Callback when a scale gesture starts.
  void onDragStart(details) {
    if(details is ScaleStartDetails){
      widget.onScaleStart(true);
      translationUpdater.value = details.focalPoint;
    } else if(details is DragStartDetails){
      initialFocalPoint = details.globalPosition;
      // Get the center of the widget
      final renderBox = widget.centerKey.currentContext!.findRenderObject() as RenderBox;
      widgetCenter = renderBox.localToGlobal(Offset.zero) + renderBox.size.center(Offset.zero);

      // Calculate initial distance and rotation
      initialDistance = (initialFocalPoint - widgetCenter).distance;
      initialRotation = atan2(initialFocalPoint.dy - widgetCenter.dy, initialFocalPoint.dx - widgetCenter.dx);

      centerOffset = getFocalPoint(widget.centerKey);
    }
    recordOldScale = recordScale;
    scaleUpdater.value = 1.0;
    rotationUpdater.value = 0.0;
  }

  // Callback when a scale gesture ends.
  void onDragEnd(details) {
    if(details is ScaleEndDetails){
      widget.onScaleEnd();
    } else {
      //Pan End
    }
  }

  // Callback for handling scale updates.
  void onDragUpdate(details) {
    double scale = 0;
    double rotation = 0;
    if(details is ScaleUpdateDetails){
      widget.onScaleStart(true);
      scale = details.scale;
      rotation = details.rotation;
    } else if(details is DragUpdateDetails) {
      widget.onScaleStart(false);
      Offset currentFocalPoint = details.globalPosition;

      double newDistance = (currentFocalPoint - widgetCenter).distance;
      double scaleFactor = newDistance / initialDistance;
      scale = scaleFactor;

      double currentRotation = atan2(currentFocalPoint.dy - widgetCenter.dy, currentFocalPoint.dx - widgetCenter.dx);
      rotation = currentRotation - initialRotation;
    }

    // Reset transformation matrices.
    translationDeltaMatrix = Matrix4.identity();
    scaleDeltaMatrix = Matrix4.identity();
    rotationDeltaMatrix = Matrix4.identity();

    // Handle translation.
    if (widget.shouldTranslate && details is ScaleUpdateDetails) {
      Offset translationDelta = translationUpdater.update(details.focalPoint);
      translationDeltaMatrix = _translate(translationDelta);
      matrix = translationDeltaMatrix * matrix;
    }

    final focalPoint = details is ScaleUpdateDetails
        ? details.localFocalPoint
        : centerOffset;

    // Handle scaling.
    if (widget.shouldScale && scale != 1.0) {
      double sc = recordOldScale * scale;
      if (sc > widget.minScale && sc < widget.maxScale) {
        recordScale = sc;
        double scaleDelta = scaleUpdater.update(scale);
        scaleDeltaMatrix = _scale(scaleDelta, focalPoint);
        matrix = scaleDeltaMatrix * matrix;
      }
    }

    // Handle rotation.
    if (widget.shouldRotate && rotation != 0.0) {
      double rotationDelta = rotationUpdater.update(rotation);
      rotationDeltaMatrix = _rotate(rotationDelta, focalPoint);
      matrix = rotationDeltaMatrix * matrix;
    }

    // Notify the callback with the updated scale and matrix.
    widget.onUpdate(recordScale, matrix);
  }

  // Helper function for translation matrix.
  Matrix4 _translate(Offset translation) {
    var dx = translation.dx;
    var dy = translation.dy;

    return Matrix4(1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
  }

  // Helper function for scaling matrix.
  Matrix4 _scale(double scale, Offset focalPoint) {
    var dx = (1 - scale) * focalPoint.dx;
    var dy = (1 - scale) * focalPoint.dy;

    return Matrix4(scale, 0, 0, 0, 0, scale, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
  }

  // Helper function for rotation matrix.
  Matrix4 _rotate(double angle, Offset focalPoint) {
    var c = cos(angle);
    var s = sin(angle);
    var dx = (1 - c) * focalPoint.dx + s * focalPoint.dy;
    var dy = (1 - c) * focalPoint.dy - s * focalPoint.dx;

    return Matrix4(c, s, 0, 0, -s, c, 0, 0, 0, 0, 1, 0, dx, dy, 0, 1);
  }
}

// Callback type for updating values.
typedef OnUpdate<T> = T Function(T oldValue, T newValue);

// ValueUpdater class for tracking and updating values.
class ValueUpdater<T> {
  final OnUpdate<T> onUpdate;
  T value;

  ValueUpdater({
    required this.value,
    required this.onUpdate,
  });

  T update(T newValue) {
    T updated = onUpdate(value, newValue);
    value = newValue;
    return updated;
  }
}

Offset getFocalPoint(GlobalKey widgetKey){
  final RenderBox parentRenderBox =
  LindiStickerWidget.globalKey.currentContext?.findRenderObject() as RenderBox;
  final RenderBox childRenderBox =
  widgetKey.currentContext?.findRenderObject() as RenderBox;

  // Get global positions
  final Offset parentGlobalPosition = parentRenderBox.localToGlobal(Offset.zero);
  final Offset childGlobalPosition = childRenderBox.localToGlobal(Offset.zero);

  // Calculate child's position relative to the parent
  final Offset relativePosition = childGlobalPosition - parentGlobalPosition;
  return relativePosition;
}
