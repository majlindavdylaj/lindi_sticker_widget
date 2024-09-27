import 'package:flutter/material.dart';

class LindiStickerIcon {
  // The main icon associated with item.
  IconData icon;

  // Size of the main icon.
  double iconSize;

  // The alignment of the item on the screen.
  Alignment alignment;

  // A flag indicating whether the sticker item is lock.
  bool isLock;

  // An optional secondary icon associated with item if the item is lock.
  IconData? lockedIcon;

  // The color of the main icon.
  Color iconColor;

  // The background color of the sticker item.
  Color backgroundColor;

  // A callback function that is triggered when the sticker item is tapped.
  Function()? onTap;

  /// Constructs a [LindiStickerIcon] with the provided properties.
  ///
  /// [icon] is required and represents the main icon.
  /// [alignment] is required and defines the alignment of the sticker item.
  /// [isLock] determines if the item is lock; defaults to `false`.
  /// [iconColor] sets the color of the main icon; defaults to `Colors.black`.
  /// [backgroundColor] sets the background color of the item; defaults to `Colors.white`.
  /// [lockedIcon] is an optional secondary icon if the item is lock.
  /// [onTap] is a callback that is called when the item is tapped.
  LindiStickerIcon(
      {required this.icon,
      required this.alignment,
      this.iconSize = 14,
      this.isLock = false,
      this.iconColor = Colors.black,
      this.backgroundColor = Colors.white,
      this.lockedIcon,
      this.onTap});
}
