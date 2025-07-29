## 1.1.0

* Added `dismissOnTapOutside` and `tapToSelect` properties to `LindiController` for more flexible sticker interaction behavior
* Bug fixes

## 1.0.4

* Added `pixelRatio` to `saveAsUint8List` to improve image quality
* Removed deprecated initial position parameter
* Update project to latest Flutter version

## 1.0.3

* Initial widget position is deprecated
* Fixed when `selectedWidget` returns null
* Fixed when stickers goes outside of child (background)
* Update project

## 1.0.1

* **Breaking**: `LindiController` is changed. Now you can customize `LindiStickerIcon` inside controller.
```dart
LindiController controller = LindiController(
  icons: [
    LindiStickerIcon(
        icon: Icons.done,
        alignment: Alignment.topRight,
        onTap: () {
          controller.selectedWidget!.done();
        }),
    LindiStickerIcon(
        icon: Icons.close,
        alignment: Alignment.topLeft,
        onTap: () {
          controller.selectedWidget!.delete();
        }),
    .
    .
    .
  ],
);
```
* **Breaking**: `controller.addWidget` is renamed to `controller.add`
* **Breaking**: Get index of selected widget is changed.
```dart
controller.onPositionChange((index) {
  print("widgets size: ${controller.widgets.length}, current index: $index");
});
```
* **Breaking**: `updateWidget` is changed.
```dart
controller.selectedWidget!.edit(const Text('Hello'));
```
* Resize widget
* Initial widget position
* Bug fixes

## 0.1.3

* Get index of selected widget
* Update widget
* Bug fixes

## 0.1.1

* Lock Widget
* Now easier to scale widget
* Customize
* Bug fixes

## 0.0.4

* Publish