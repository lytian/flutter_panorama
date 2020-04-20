package com.iwiteks.flutter_panorama;

import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.AsyncTask;
import android.text.TextUtils;
import android.view.View;
import android.widget.Toast;

import com.google.vr.sdk.widgets.pano.VrPanoramaView;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.security.InvalidParameterException;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.view.FlutterMain;

public class FlutterPanoramaView implements PlatformView, MethodChannel.MethodCallHandler {

    private final MethodChannel methodChannel;
    private final VrPanoramaView panoramaView;

    private ImageLoaderTask imageLoaderTask;
    private VrPanoramaView.Options options = new VrPanoramaView.Options();;

    FlutterPanoramaView(final Context context,
                        BinaryMessenger messenger,
                        int id,
                        Map<String, Object> params) {
        panoramaView = new VrPanoramaView(context);
        // 配置参数
        if (params.get("enableInfoButton") == null || !(boolean) params.get("enableInfoButton")) {
            panoramaView.setInfoButtonEnabled(false);
        }
        if (params.get("enableFullButton") == null || !(boolean) params.get("enableFullButton")) {
            panoramaView.setFullscreenButtonEnabled(false);
        }
        if (params.get("enableStereoModeButton") == null || !(boolean) params.get("enableStereoModeButton")) {
            panoramaView.setStereoModeButtonEnabled(false);
        }
        if (params.get("imageType") != null) {
            options.inputType = (int) params.get("imageType") ;
        }
        // 加载图像
        imageLoaderTask = new ImageLoaderTask(context);
        imageLoaderTask.execute((String)params.get("uri"), (String)params.get("asset"), (String)params.get("packageName"));

        // 注册MethodChannel
        methodChannel = new MethodChannel(messenger, "plugins.vincent/panorama_" + id);
        methodChannel.setMethodCallHandler(this);
    }

    @Override
    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
        // 处理Flutter端传过来的方法
    }

    @Override
    public View getView() {
        return panoramaView;
    }

    @Override
    public void dispose() {
        imageLoaderTask = null;
    }

    private boolean isHTTP(Uri uri) {
        if (uri == null || uri.getScheme() == null) {
            return false;
        }
        String scheme = uri.getScheme();
        return scheme.equals("http") || scheme.equals("https");
    }

    private class ImageLoaderTask extends AsyncTask<String, String, Bitmap> {
        final Context context;

        public ImageLoaderTask(Context context) {
            this.context = context;
        }

        @Override
        protected Bitmap doInBackground(String... strings) {
            if (strings == null || strings.length < 1) {
                return null;
            }
            String path = strings[0];
            String asset = strings[1];
            String packageName = strings[2];
            Bitmap image = null;
            if (!TextUtils.isEmpty(asset)) {
                String assetKey;
                if (!TextUtils.isEmpty(packageName)) {
                    assetKey = FlutterMain.getLookupKeyForAsset(asset, packageName);
                } else {
                    assetKey = FlutterMain.getLookupKeyForAsset(asset);
                }
                try {
                    AssetManager assetManager = context.getAssets();
                    AssetFileDescriptor fileDescriptor = assetManager.openFd(assetKey);
                    image = BitmapFactory.decodeStream(fileDescriptor.createInputStream());
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else {
                Uri uri = Uri.parse(path);
                if (isHTTP(uri)) {
                    // 网络资源
                    try {
                        URL fileUrl = new URL(path);
                        InputStream is = fileUrl.openConnection().getInputStream();
                        image = BitmapFactory.decodeStream(is);
                        is.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                } else {
                    // 存储卡资源
                    try {
                        File file = new File(uri.getPath());
                        if (!file.exists()) {
                            throw new FileNotFoundException();
                        }
                        // Decoding a large image can take 100+ ms.
                        image = BitmapFactory.decodeFile(uri.getPath());
                        panoramaView.loadImageFromBitmap(image, null);

                    } catch (IOException | InvalidParameterException e) {
                        e.printStackTrace();
                    }
                }
            }
            return image;
        }

        @Override
        protected void onPostExecute(Bitmap bitmap) {
            super.onPostExecute(bitmap);
            methodChannel.invokeMethod("onImageLoaded", bitmap == null ? 0 : 1);
            // 处理回调
            if (bitmap == null) {
                Toast.makeText(context, "全景图片加载失败",Toast.LENGTH_LONG).show();
                return;
            }
            panoramaView.loadImageFromBitmap(bitmap, options);
        }
    }
}


