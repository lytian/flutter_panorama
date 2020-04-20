package com.iwiteks.flutter_panorama;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlutterPanoramaPlugin */
public class FlutterPanoramaPlugin implements FlutterPlugin, ActivityAware {
  private FlutterPluginBinding flutterPluginBinding;

  public static void registerWith(Registrar registrar) {
    registrar
            .platformViewRegistry()
            .registerViewFactory(
                    "plugins.vincent/panorama",
                    new FlutterPanoramaFactory(registrar.activeContext(), registrar.messenger()));
  }

  @Override
  public void onAttachedToEngine(FlutterPluginBinding binding) {
    this.flutterPluginBinding = binding;
  }

  @Override
  public void onDetachedFromEngine(FlutterPluginBinding binding) {
    this.flutterPluginBinding = null;
  }

  @Override
  public void onAttachedToActivity(ActivityPluginBinding binding) {
    BinaryMessenger messenger = this.flutterPluginBinding.getBinaryMessenger();
    this.flutterPluginBinding
            .getPlatformViewRegistry()
            .registerViewFactory(
                    "plugins.vincent/panorama", new FlutterPanoramaFactory(binding.getActivity(), messenger));
  }

  @Override
  public void onDetachedFromActivityForConfigChanges() {
//    onDetachedFromActivity();
  }

  @Override
  public void onReattachedToActivityForConfigChanges(ActivityPluginBinding binding) {
//    onAttachedToActivity(binding);
  }

  @Override
  public void onDetachedFromActivity() {
  }
}
