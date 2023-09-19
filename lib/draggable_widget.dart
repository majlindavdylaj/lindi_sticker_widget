import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_gesture_detector.dart';

/// A Flutter widget class DraggableWidget for displaying and managing draggable stickers.
///
//ignore: must_be_immutable
class DraggableWidget extends StatelessWidget {
  /// Properties to customize the appearance and behavior of the widget.
  ///
  Widget child;
  Color borderColor;
  Color iconColor;
  bool showDone;
  bool showClose;
  bool showFlip;
  bool showStack;
  bool showLock;
  bool showAllBorders;
  bool shouldMove;
  bool shouldRotate;
  bool shouldScale;
  double minScale;
  double maxScale;

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
  Function(Key?) onBorder;
  Function(Key?) onDelete;
  Function(Key?) onLayer;

  /// Notifiers for updating the widget when changes occur.
  ///
  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  final ValueNotifier<bool> updater = ValueNotifier(true);

  /// Constructor to initialize the widget's properties.
  ///
  DraggableWidget(
      {super.key,
      required this.child,
      required this.borderColor,
      required this.iconColor,
      required this.showDone,
      required this.showClose,
      required this.showFlip,
      required this.showStack,
      required this.showLock,
      required this.showAllBorders,
      required this.shouldMove,
      required this.shouldRotate,
      required this.shouldScale,
      required this.minScale,
      required this.maxScale,
      required this.onBorder,
      required this.onDelete,
      required this.onLayer});

  // Method to update the widget's border visibility.
  update(border) {
    _showBorder = border;
    updater.value = !updater.value;
  }

  // Method to flip the widget.
  _flip() {
    _isFlip = !_isFlip;
    updater.value = !updater.value;
  }

  // Method to mark the widget as "done" and hide its border.
  _done() {
    _showBorder = false;
    updater.value = !updater.value;
  }

  // Method to lock/unlock the widget's interactive features.
  _lock() {
    _isLock = !_isLock;
    showDone = !_isLock;
    showClose = !_isLock;
    showFlip = !_isLock;
    showStack = !_isLock;
    shouldScale = !_isLock;
    shouldRotate = !_isLock;
    shouldMove = !_isLock;
    updater.value = !updater.value;
  }

  @override
  Widget build(BuildContext context) {
    // Build the widget based on ValueListenable for updates.
    return ValueListenableBuilder(
        valueListenable: updater,
        builder: (_, __, ___) {
          // Calculate sizes and dimensions based on the current scale.
          double circleSize = 24 / _scale;
          double iconSize = 13 / _scale;
          double marginSize = 11 / _scale;

          // LindiGestureDetector for handling scaling, rotating, and translating the widget.
          return LindiGestureDetector(
            shouldTranslate: shouldMove,
            shouldRotate: shouldRotate,
            shouldScale: shouldScale,
            minScale: minScale,
            maxScale: maxScale,
            onScaleStart: () {
              _isUpdating = true;
              onBorder(key);
            },
            onScaleEnd: () {
              _isUpdating = false;
              updater.value = !updater.value;
            },
            onUpdate: (s, m) {
              _scale = s;
              notifier.value = m;
            },
            child: AnimatedBuilder(
              animation: notifier,
              builder: (ctx, child) {
                // Apply the transformation matrix to the child widget.
                Widget transformChild = Transform(
                  transform: notifier.value,
                  child: Center(
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(marginSize),
                          padding: EdgeInsets.all(13 / _scale),
                          decoration: (showAllBorders && _showBorder)
                              ? BoxDecoration(
                                  border: Border.all(
                                      color: borderColor, width: 1.5 / _scale),
                                )
                              : null,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Transform.flip(
                                flipX: _isFlip, child: this.child),
                          ),
                        ),
                        // Widgets for interaction (e.g., delete, flip, etc.).
                        if (showAllBorders && _showBorder && showDone)
                          Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _done();
                              },
                              child: SizedBox(
                                width: circleSize,
                                height: circleSize,
                                child: CircleAvatar(
                                    backgroundColor: borderColor,
                                    child: Icon(
                                      Icons.done,
                                      size: iconSize,
                                      color: iconColor,
                                    )),
                              ),
                            ),
                          ),
                        if (showAllBorders && _showBorder && showClose)
                          Positioned(
                            left: 0,
                            child: GestureDetector(
                              onTap: () {
                                onDelete(key);
                              },
                              child: SizedBox(
                                width: circleSize,
                                height: circleSize,
                                child: CircleAvatar(
                                    backgroundColor: borderColor,
                                    child: Icon(
                                      Icons.close,
                                      size: iconSize,
                                      color: iconColor,
                                    )),
                              ),
                            ),
                          ),
                        if (showAllBorders && _showBorder && showFlip)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () {
                                _flip();
                              },
                              child: SizedBox(
                                width: circleSize,
                                height: circleSize,
                                child: CircleAvatar(
                                    backgroundColor: borderColor,
                                    child: Icon(
                                      Icons.flip,
                                      size: iconSize,
                                      color: iconColor,
                                    )),
                              ),
                            ),
                          ),
                        if (showAllBorders && _showBorder && showStack)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                onLayer(key);
                              },
                              child: SizedBox(
                                width: circleSize,
                                height: circleSize,
                                child: CircleAvatar(
                                    backgroundColor: borderColor,
                                    child: Icon(
                                      Icons.layers,
                                      size: iconSize,
                                      color: iconColor,
                                    )),
                              ),
                            ),
                          ),
                        if (showAllBorders && _showBorder && showLock)
                          Positioned(
                            left: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _lock();
                              },
                              child: SizedBox(
                                width: circleSize,
                                height: circleSize,
                                child: CircleAvatar(
                                    backgroundColor: borderColor,
                                    child: Icon(
                                      _isLock ? Icons.lock : Icons.lock_open,
                                      size: iconSize,
                                      color: iconColor,
                                    )),
                              ),
                            ),
                          ),
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
