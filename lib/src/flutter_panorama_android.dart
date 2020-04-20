import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_panorama/platform_interface.dart';
import 'package:flutter_panorama/src/flutter_panorama_method_channel.dart';

class AndroidPanoramaView extends FlutterPanoramaPlatform {

  @override
  Widget build(BuildContext context, Map<String, dynamic> creationParams, PanoramaPlatformCallbacksHandler callbacksHandler) {
//    Map<String, dynamic> creationParams = dataSource.toJson();
//    creationParams.
    return AndroidView(
      viewType: "plugins.vincent/panorama",
      creationParams: creationParams,
      creationParamsCodec: const StandardMessageCodec(),
      onPlatformViewCreated: (int id) {
        MethodChannelPanoramaPlatform(id, callbacksHandler);
      },
    );
  }

}