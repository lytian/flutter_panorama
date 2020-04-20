import 'package:flutter/services.dart';
import 'package:flutter_panorama/platform_interface.dart';

class MethodChannelPanoramaPlatform {

  final MethodChannel _channel;
  final PanoramaPlatformCallbacksHandler _callbacksHandler;

  MethodChannelPanoramaPlatform(int id, this._callbacksHandler) : assert(_callbacksHandler != null), _channel = MethodChannel('plugins.vincent/panorama_$id') {
    _channel.setMethodCallHandler(_onMethodCall);
  }

  Future<bool> _onMethodCall(MethodCall call) async {
    switch(call.method) {
      case "onImageLoaded":
        final int state = call.arguments;
        _callbacksHandler.onImageLoaded(state);
        return true;
    }
    return null;
  }

}