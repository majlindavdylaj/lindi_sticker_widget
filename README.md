# lindi_sticker_widget

## Features

&nbsp; Rotate </br>
&nbsp; Resize</br>
&nbsp; Move</br>
&nbsp; Layer Update (Change Stack position)</br>
&nbsp; Delete</br>
&nbsp; Flip</br>
&nbsp; Lock
<br>
<br>

## Getting started

This plugin is available on Pub: [https://pub.dev/packages/lindi_sticker_widget](https://pub.dev/packages/lindi_sticker_widget)

Add this to `dependencies` in your app's `pubspec.yaml`

```yaml
lindi_sticker_widget : latest_version
```

## Usage

Sample code to integrate can be found in [example/lib/main.dart](example/lib/main.dart).

#### LindiController

```dart
  LindiController controller = LindiController();
```

#### Custom LindiController

```dart
  LindiController controller = LindiController(
      borderColor: Colors.white,
      iconColor: Colors.black,
      showDone: true,
      showClose: true,
      showFlip: true,
      showStack: true,
      showLock: true,
      showAllBorders: true,
      shouldScale: true,
      shouldRotate: true,
      shouldMove: true,
      minScale: 0.5,
      maxScale: 4,
    );
```

#### Integrate LindiStickerWidget

```dart
LindiStickerWidget(
    controller: controller,
    child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Image.network('https://picsum.photos/200/300', fit: BoxFit.cover)
    ),
)
```

#### Add Widget to LindiStickerWidget

```dart
controller.addWidget(
    Text('Hello World')
);
```

#### Save LindiStickerWidget as Uint8List

```dart
Uint8List? image = await controller.saveAsUint8List();
```

## Screenshot

![Demo](/example/assets/Screenshot.png)

***

### :heart:  Found this project useful?

If you found this project useful, then please consider giving it a :star:  on Github and sharing it with your friends via social media.
