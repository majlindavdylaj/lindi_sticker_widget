import 'package:flutter/material.dart';
import 'package:lindi_sticker_widget/lindi_controller.dart';
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

  LindiController controller = LindiController();

  List<Widget> widgets = [
    SizedBox(
        height: 150,
        width: 150,
        child: Image.network('https://picsum.photos/200/300')
    ),
    const Icon(Icons.favorite, color: Colors.red, size: 50)
  ];

  @override
  void initState() {
    for (var element in widgets) {
      controller.addWidget(element);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lindi Sticker Widget'),
      ),
      body: Center(
        child: LindiStickerWidget(
          controller: controller,
          child: Container(
            color: Colors.yellow,
            width: double.infinity,
            height: 300,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          controller.addWidget(
            Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(Radius.circular(20))
              ),
              child: const Text(
                'This is a Text',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
