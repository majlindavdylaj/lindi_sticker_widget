import 'dart:math';

import 'package:flutter/widgets.dart';

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

  /// Alignment of the focal point.
  ///
  final Alignment? focalPointAlignment;

  /// Callback functions for scale start and end.
  ///
  final VoidCallback onScaleStart;
  final VoidCallback onScaleEnd;

  /// Minimum and maximum scale values.
  ///
  final double minScale;
  final double maxScale;

  const LindiGestureDetector(
      {Key? key,
      required this.onUpdate,
      required this.child,
      this.shouldTranslate = true,
      this.shouldScale = true,
      this.shouldRotate = true,
      this.clipChild = true,
      this.focalPointAlignment,
      this.behavior = HitTestBehavior.deferToChild,
      required this.onScaleStart,
      required this.onScaleEnd,
      required this.minScale,
      required this.maxScale})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    // Wrap the child widget in a ClipRect if clipping is enabled.
    Widget child =
        widget.clipChild ? ClipRect(child: widget.child) : widget.child;

    // Create a GestureDetector to handle gestures.
    return GestureDetector(
      behavior: widget.behavior,
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
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
  void onScaleStart(ScaleStartDetails details) {
    widget.onScaleStart();
    translationUpdater.value = details.focalPoint;
    recordOldScale = recordScale;
    scaleUpdater.value = 1.0;
    rotationUpdater.value = 0.0;
  }

  // Callback when a scale gesture ends.
  void onScaleEnd(ScaleEndDetails details) {
    widget.onScaleEnd();
  }

  // Callback for handling scale updates.
  void onScaleUpdate(ScaleUpdateDetails details) {
    widget.onScaleStart();

    // Reset transformation matrices.
    translationDeltaMatrix = Matrix4.identity();
    scaleDeltaMatrix = Matrix4.identity();
    rotationDeltaMatrix = Matrix4.identity();

    // Handle translation.
    if (widget.shouldTranslate) {
      Offset translationDelta = translationUpdater.update(details.focalPoint);
      translationDeltaMatrix = _translate(translationDelta);
      matrix = translationDeltaMatrix * matrix;
    }

    final focalPointAlignment = widget.focalPointAlignment;
    final focalPoint = focalPointAlignment == null
        ? details.localFocalPoint
        : focalPointAlignment.alongSize(context.size!);

    // Handle scaling.
    if (widget.shouldScale && details.scale != 1.0) {
      double sc = recordOldScale * details.scale;
      if (sc > widget.minScale && sc < widget.maxScale) {
        recordScale = sc;
        double scaleDelta = scaleUpdater.update(details.scale);
        scaleDeltaMatrix = _scale(scaleDelta, focalPoint);
        matrix = scaleDeltaMatrix * matrix;
      }
    }

    // Handle rotation.
    if (widget.shouldRotate && details.rotation != 0.0) {
      double rotationDelta = rotationUpdater.update(details.rotation);
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
