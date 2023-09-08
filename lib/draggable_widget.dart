import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/matrix_gesture_detector.dart';

//ignore: must_be_immutable
class DraggableWidget extends StatelessWidget {
  final Widget child;
  final Color borderColor;
  final Color iconColor;

  bool showBorder = true;
  bool isFlip = false;

  Function(Key?) onBorder;
  Function(Key?) onDelete;
  Function(Key?) onLayer;

  final ValueNotifier<Matrix4> notifier = ValueNotifier(Matrix4.identity());
  final ValueNotifier<bool> updater = ValueNotifier(true);

  DraggableWidget(
      {super.key,
      required this.child,
      required this.borderColor,
      required this.iconColor,
      required this.onBorder,
      required this.onDelete,
      required this.onLayer});

  update(border) {
    showBorder = border;
    updater.value = !updater.value;
  }

  _flip() {
    isFlip = !isFlip;
    updater.value = !updater.value;
  }

  _done() {
    showBorder = false;
    updater.value = !updater.value;
  }

  @override
  Widget build(BuildContext context) {
    return MatrixGestureDetector(
      onScaleStart: () {
        onBorder(key);
      },
      onMatrixUpdate: (m, tm, sm, rm) {
        notifier.value = m;
      },
      child: ValueListenableBuilder(
          valueListenable: updater,
          builder: (_, __, ___) {
            return AnimatedBuilder(
              animation: notifier,
              builder: (ctx, child) {
                return Transform(
                  transform: notifier.value,
                  child: Align(
                    alignment: Alignment.center,
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          padding: const EdgeInsets.all(15.0),
                          decoration: showBorder
                              ? BoxDecoration(
                                  border: Border.all(color: borderColor),
                                )
                              : null,
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Transform.flip(
                                flipX: isFlip, child: this.child),
                          ),
                        ),
                        if (showBorder)
                          Positioned(
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                _done();
                              },
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircleAvatar(
                                    backgroundColor: borderColor,
                                    child: Icon(
                                      Icons.done,
                                      size: 14,
                                      color: iconColor,
                                    )),
                              ),
                            ),
                          ),
                        if (showBorder)
                          Positioned(
                            left: 0,
                            child: GestureDetector(
                              onTap: () {
                                onDelete(key);
                              },
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircleAvatar(
                                    backgroundColor: borderColor,
                                    child: Icon(
                                      Icons.close,
                                      size: 14,
                                      color: iconColor,
                                    )),
                              ),
                            ),
                          ),
                        if (showBorder)
                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () {
                                _flip();
                              },
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircleAvatar(
                                    backgroundColor: borderColor,
                                    child: Icon(
                                      Icons.flip,
                                      size: 14,
                                      color: iconColor,
                                    )),
                              ),
                            ),
                          ),
                        if (showBorder)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                onLayer(key);
                              },
                              child: SizedBox(
                                width: 22,
                                height: 22,
                                child: CircleAvatar(
                                    backgroundColor: borderColor,
                                    child: Icon(
                                      Icons.layers,
                                      size: 14,
                                      color: iconColor,
                                    )),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                );
              },
            );
          }),
    );
  }
}
