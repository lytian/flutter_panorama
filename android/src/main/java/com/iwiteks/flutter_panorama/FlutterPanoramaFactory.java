package com.iwiteks.flutter_panorama;

import android.content.Context;

import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

public class FlutterPanoramaFactory extends PlatformViewFactory {
    private final BinaryMessenger messenger;
    private final Context context;

    FlutterPanoramaFactory(Context context, BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.context = context;
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context1, int viewId, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        return new FlutterPanoramaView(this.context, messenger, viewId, params);
    }
}
