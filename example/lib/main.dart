import 'package:flutter/material.dart';

import 'package:flutter_panorama/flutter_panorama.dart';
import 'package:flutter_panorama/platform_interface.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
//          child: FlutterPanorama.assets("images/xishui_pano.jpg"),
          child: FlutterPanorama.network('https://storage.googleapis.com/vrview/examples/coral.jpg',
            imageType: ImageType.MEDIA_STEREO_TOP_BOTTOM,
            onImageLoaded: (state) {
              print("------------------------------- ${state == 1 ? '图片加载完成' : '图片加载失败'}");
            },
          ),
        )
      ),
    );
  }
}
