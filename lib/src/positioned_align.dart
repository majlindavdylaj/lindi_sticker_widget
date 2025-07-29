import 'package:flutter/material.dart';

/// A custom widget that positions its child based on the provided [alignment].
class PositionedAlign extends StatelessWidget {
  // The alignment position for the child widget.
  final Alignment alignment;

  // The child widget to be positioned.
  final Widget child;

  /// Creates a [PositionedAlign] widget.
  ///
  /// [alignment] determines the position of the child within the parent widget.
  /// [child] is the widget that will be positioned according to the alignment.
  const PositionedAlign(
      {super.key, required this.alignment, required this.child});

  @override
  Widget build(BuildContext context) {
    // Determines the position of the child widget based on the alignment value.
    switch (alignment) {
      case Alignment.topLeft:
        // Positions the child at the top-left corner.
        return Positioned(
          top: 0,
          left: 0,
          child: child,
        );
      case Alignment.topCenter:
        // Positions the child at the top-center of the parent.
        return Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: child,
        );
      case Alignment.topRight:
        // Positions the child at the top-right corner.
        return Positioned(
          top: 0,
          right: 0,
          child: child,
        );
      case Alignment.centerLeft:
        // Positions the child at the center-left of the parent.
        return Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          child: child,
        );
      case Alignment.center:
        // Positions the child at the center of the parent.
        return Positioned(
          top: 0,
          bottom: 0,
          child: child,
        );
      case Alignment.centerRight:
        // Positions the child at the center-right of the parent.
        return Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          child: child,
        );
      case Alignment.bottomLeft:
        // Positions the child at the bottom-left corner.
        return Positioned(
          bottom: 0,
          left: 0,
          child: child,
        );
      case Alignment.bottomCenter:
        // Positions the child at the bottom-center of the parent.
        return Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: child,
        );
      case Alignment.bottomRight:
        // Positions the child at the bottom-right corner.
        return Positioned(
          bottom: 0,
          right: 0,
          child: child,
        );
      default:
        // If an unknown alignment is provided, fallback to a default positioning.
        return SizedBox(
          child: child,
        );
    }
  }
}
