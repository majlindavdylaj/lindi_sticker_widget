import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
import 'package:lindi_sticker_widget/lindi_sticker_icon.dart';
import 'package:lindi_sticker_widget/lindi_sticker_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lindi Sticker Widget',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late LindiController controller;

  List<Widget> widgets = [
    SizedBox(
        height: 100,
        width: 100,
        child: Image.network('https://picsum.photos/200/200')),
    const Icon(Icons.favorite, color: Colors.red, size: 50)
  ];

  Uint8List? image;

  @override
  void initState() {
    controller = LindiController(
      borderColor: Colors.white,
      icons: [
        LindiStickerIcon(
            icon: Icons.done,
            alignment: Alignment.topRight,
            onTap: () {
              controller.selectedWidget!.done();
            }),
        LindiStickerIcon(
            icon: Icons.lock_open,
            lockedIcon: Icons.lock,
            alignment: Alignment.topCenter,
            type: IconType.lock,
            onTap: () {
              controller.selectedWidget!.lock();
            }),
        LindiStickerIcon(
            icon: Icons.close,
            alignment: Alignment.topLeft,
            onTap: () {
              controller.selectedWidget!.delete();
            }),
        LindiStickerIcon(
            icon: Icons.edit,
            alignment: Alignment.centerLeft,
            onTap: () {
              controller.selectedWidget!
                  .edit(const Icon(Icons.star, size: 50, color: Colors.yellow));
            }),
        LindiStickerIcon(
            icon: Icons.layers,
            alignment: Alignment.centerRight,
            onTap: () {
              controller.selectedWidget!.stack();
            }),
        LindiStickerIcon(
            icon: Icons.flip,
            alignment: Alignment.bottomLeft,
            onTap: () {
              controller.selectedWidget!.flip();
            }),
        LindiStickerIcon(
            icon: Icons.crop_free,
            alignment: Alignment.bottomRight,
            type: IconType.resize),
      ],
    );

    controller.addAll(widgets);

    controller.onPositionChange((index) {
      debugPrint(
          "widgets size: ${controller.widgets.length}, current index: $index");
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lindi Sticker Widget'),
      ),
      body: Column(
        children: [
          Expanded(
            child: LindiStickerWidget(
              controller: controller,
              child: SizedBox(
                  width: double.infinity,
                  height: double.infinity,
                  child: Image.network('https://picsum.photos/200/300',
                      fit: BoxFit.cover)),
            ),
          ),
          if (image != null)
            Expanded(
              child: Image.memory(image!),
            )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Widget widget = Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: const Text(
              'This is a Text',
              style: TextStyle(color: Colors.white),
            ),
          );
          controller.add(widget, position: Alignment.center);
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
