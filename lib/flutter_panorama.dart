
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_panorama/platform_interface.dart';
import 'package:flutter_panorama/src/flutter_panorama_android.dart';
import 'package:flutter_panorama/src/flutter_panorama_ios.dart';

typedef void ImageLoadedCallback(int state);

class FlutterPanorama extends StatelessWidget {
  final String dataSource;
  final DataSourceType dataSourceType;
  final String package;
  final ImageType imageType;
  final bool enableInfoButton;
  final bool enableFullButton;
  final bool enableStereoModeButton;
  final ImageLoadedCallback onImageLoaded;

  _PlatformCallbacksHandler _platformCallbacksHandler;


  FlutterPanorama.assets(this.dataSource, {
    this.package,
    this.imageType: ImageType.MEDIA_MONOSCOPIC,
    this.enableInfoButton,
    this.enableFullButton,
    this.enableStereoModeButton,
    this.onImageLoaded,
  }) : dataSourceType = DataSourceType.asset, super();

  FlutterPanorama.network(this.dataSource, {
    this.imageType: ImageType.MEDIA_MONOSCOPIC,
    this.enableInfoButton,
    this.enableFullButton,
    this.enableStereoModeButton,
    this.onImageLoaded,
  }) : dataSourceType = DataSourceType.network, package = null, super();

  FlutterPanorama.file(this.dataSource, {
    this.imageType: ImageType.MEDIA_MONOSCOPIC,
    this.enableInfoButton,
    this.enableFullButton,
    this.enableStereoModeButton,
    this.onImageLoaded,
  }) :  dataSourceType = DataSourceType.file, package = null, super();

  static FlutterPanoramaPlatform _platform;

  static set platform(FlutterPanoramaPlatform platform) {
    _platform = platform;
  }

  static FlutterPanoramaPlatform get platform {
    if (_platform == null) {
      switch (defaultTargetPlatform) {
        case TargetPlatform.android:
          _platform = AndroidPanoramaView();
          break;
        case TargetPlatform.iOS:
          _platform = IosPanoramaView();
          break;
        default:
          throw UnsupportedError(
              "Trying to use the default panorama implementation for $defaultTargetPlatform but there isn't a default one");
      }
    }
    return _platform;
  }

  @override
  Widget build(BuildContext context) {
    _platformCallbacksHandler = _PlatformCallbacksHandler(this);

    return FlutterPanorama.platform.build(
        context,
        _toCreationParams(),
        _platformCallbacksHandler
    );
  }

  Map<String, dynamic> _toCreationParams() {
    DataSource dataSourceDescription;
    switch (dataSourceType) {
      case DataSourceType.asset:
        dataSourceDescription = DataSource(
          sourceType: DataSourceType.asset,
          asset: dataSource,
          package: package,
        );
        break;
      case DataSourceType.network:
        dataSourceDescription = DataSource(
            sourceType: DataSourceType.network,
            uri: dataSource
        );
        break;
      case DataSourceType.file:
        dataSourceDescription = DataSource(
          sourceType: DataSourceType.file,
          uri: dataSource,
        );
        break;
    }
    Map<String, dynamic> creationParams = dataSourceDescription.toJson();
    creationParams["imageType"] = this.imageType.index;
    creationParams["enableInfoButton"] = this.enableInfoButton;
    creationParams["enableFullButton"] = this.enableFullButton;
    creationParams["enableStereoModeButton"] = this.enableStereoModeButton;
    return creationParams;
  }
}

class _PlatformCallbacksHandler implements PanoramaPlatformCallbacksHandler {
  FlutterPanorama _widget;

  _PlatformCallbacksHandler(this._widget);

  @override
  void onImageLoaded(int state) {
    _widget.onImageLoaded(state);
  }
}