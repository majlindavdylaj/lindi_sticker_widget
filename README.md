# lindi_sticker_widget

## Features

&nbsp; Rotate </br>
&nbsp; Resize</br>
&nbsp; Move</br>
&nbsp; Layer Update (Change Stack position)</br>
&nbsp; Delete</br>
&nbsp; Flip
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

#### Integrate LindiStickerWidget

```dart
LindiStickerWidget(
    controller: controller,
    child: Container(
        color: Colors.yellow,
        width: double.infinity,
        height: 300,
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

![Demo](/example/assets/Screenshot_1694168087.png)

***

### :heart:  Found this project useful?

If you found this project useful, then please consider giving it a :star:  on Github and sharing it with your friends via social media.
