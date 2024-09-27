import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_gesture_detector.dart';
import 'package:lindi_sticker_widget/lindi_sticker_icon.dart';
import 'package:lindi_sticker_widget/positioned_align.dart';

/// A Flutter widget class DraggableWidget for displaying and managing draggable stickers.
///
//ignore: must_be_immutable
class DraggableWidget extends StatelessWidget {
  late List<LindiStickerIcon> _icons;

  /// Properties to customize the appearance and behavior of the widget.
  ///
  Widget child;
  late Color _borderColor;
  late double _borderWidth;
  late bool _showBorders;
  late bool _shouldMove;
  late bool _shouldRotate;
  late bool _shouldScale;
  late double _minScale;
  late double _maxScale;
  late double _insidePadding;

  /// Internal state [_showBorder].
  ///
  /// Defaults to true
  ///
  bool _showBorder = true;

  /// Internal state[_isFlip].
  ///
  /// Defaults to false
  ///
  bool _isFlip = false;

  /// Internal state[_isLock].
  ///
  /// Defaults to false
  ///
  bool _isLock = false;

  /// Internal state[_isUpdating].
  ///
  /// Defaults to false
  ///
  bool _isUpdating = false;

  /// Internal state[_scale].
  ///
  /// Defaults 1
  ///
  double _scale = 1;

  /// Callback functions for various widget interactions.
  ///
  late Function(Key?) _onBorder;
  late Function(Key?) _onDelete;
  late Function(Key?) _onLayer;

  /// Notifiers for updating the widget when changes occur.
  ///
  final ValueNotifier<Matrix4> _notifier = ValueNotifier(Matrix4.identity());
  final ValueNotifier<bool> _updater = ValueNotifier(true);

  /// Constructor to initialize the widget's properties.
  ///
  DraggableWidget(
      {super.key,
      required icons,
      required this.child,
      required borderColor,
      required borderWidth,
      required showBorders,
      required shouldMove,
      required shouldRotate,
      required shouldScale,
      required minScale,
      required maxScale,
      required onBorder,
      required onDelete,
      required onLayer,
      required insidePadding}) {
    _icons = icons;
    _borderColor = borderColor;
    _borderWidth = borderWidth;
    _showBorders = showBorders;
    _shouldMove = shouldMove;
    _shouldRotate = shouldRotate;
    _shouldScale = shouldScale;
    _minScale = minScale;
    _maxScale = maxScale;
    _onBorder = onBorder;
    _onDelete = onDelete;
    _onLayer = onLayer;
    _insidePadding = insidePadding;
  }

  // Method to update the widget's border visibility.
  showBorder(bool showBorder) {
    _showBorder = showBorder;
    _updater.value = !_updater.value;
  }

  // Method to edit the widget.
  edit(Widget child) {
    this.child = child;
    _updater.value = !_updater.value;
  }

  // Method to flip the widget.
  flip() {
    _isFlip = !_isFlip;
    _updater.value = !_updater.value;
  }

  // Method to mark the widget as "done" and hide its border.
  done() {
    _showBorder = false;
    _updater.value = !_updater.value;
  }

  // Method to delete the widget.
  delete() {
    _onDelete(key);
  }

  // Method to stack, change position.
  stack() {
    _onLayer(key);
  }

  // Method to lock/unlock the widget's interactive features.
  lock() {
    _isLock = !_isLock;
    _shouldScale = !_isLock;
    _shouldRotate = !_isLock;
    _shouldMove = !_isLock;
    _updater.value = !_updater.value;
  }

  @override
  Widget build(BuildContext context) {
    // Build the widget based on ValueListenable for updates.
    return ValueListenableBuilder(
        valueListenable: _updater,
        builder: (_, __, ___) {
          // Calculate sizes and dimensions based on the current scale.
          double marginSize = 12 / _scale;

          // LindiGestureDetector for handling scaling, rotating, and translating the widget.
          return LindiGestureDetector(
            shouldTranslate: _shouldMove,
            shouldRotate: _shouldRotate,
            shouldScale: _shouldScale,
            minScale: _minScale,
            maxScale: _maxScale,
            onScaleStart: () {
              _isUpdating = true;
              _onBorder(key);
            },
            onScaleEnd: () {
              _isUpdating = false;
              _updater.value = !_updater.value;
            },
            onUpdate: (s, m) {
              _scale = s;
              _notifier.value = m;
            },
            child: AnimatedBuilder(
              animation: _notifier,
              builder: (ctx, child) {
                // Apply the transformation matrix to the child widget.
                Widget transformChild = Transform(
                  transform: _notifier.value,
                  child: Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.all(marginSize),
                          padding: EdgeInsets.all(_insidePadding / _scale),
                          decoration: (_showBorders && _showBorder)
                              ? BoxDecoration(
                                  border: Border.all(
                                      color: _borderColor,
                                      width: _borderWidth / _scale),
                                )
                              : null,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Transform.flip(
                                flipX: _isFlip, child: this.child),
                          ),
                        ),
                        // Widgets for interaction (e.g., delete, flip, etc.).
                        for (int i = 0; i < _icons.length; i++) ...[
                          if (_showBorders &&
                              _showBorder &&
                              (!_isLock || _icons[i].isLock))
                            Builder(builder: (context) {
                              LindiStickerIcon icon = _icons[i];
                              double circleSize = icon.iconSize + 12;
                              return PositionedAlign(
                                alignment: icon.alignment,
                                child: ScaleTransition(
                                  alignment: icon.alignment,
                                  scale: AlwaysStoppedAnimation(1 / _scale),
                                  child: GestureDetector(
                                    onTap: icon.onTap,
                                    child: SizedBox(
                                      width: circleSize,
                                      height: circleSize,
                                      child: CircleAvatar(
                                          backgroundColor: icon.backgroundColor,
                                          child: Icon(
                                            (icon.isLock &&
                                                    icon.lockedIcon != null)
                                                ? _isLock
                                                    ? icon.lockedIcon
                                                    : icon.icon
                                                : icon.icon,
                                            size: icon.iconSize,
                                            color: icon.iconColor,
                                          )),
                                    ),
                                  ),
                                ),
                              );
                            }),
                        ],
                      ],
                    ),
                  ),
                );
                return _isUpdating
                    ? Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        height: double.infinity,
                        child: transformChild)
                    : transformChild;
              },
            ),
          );
        });
  }
}
