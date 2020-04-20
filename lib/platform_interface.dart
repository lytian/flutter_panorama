
import 'package:flutter/cupertino.dart';

abstract class FlutterPanoramaPlatform {
  Widget build(
      BuildContext context,
      Map<String, dynamic> creationParams,
      PanoramaPlatformCallbacksHandler callbacksHandler,
     );

  Map<String, dynamic> dataSource2Map(DataSource dataSource) {
    Map<String, dynamic> dataSourceDescription;

    switch (dataSource.sourceType) {
      case DataSourceType.asset:
        dataSourceDescription = <String, dynamic>{
          'asset': dataSource.asset,
          'package': dataSource.package,
        };
        break;
      case DataSourceType.network:
        dataSourceDescription = <String, dynamic>{
          'uri': dataSource.uri
        };
        break;
      case DataSourceType.file:
        dataSourceDescription = <String, dynamic>{
          'uri': dataSource.uri
        };
        break;
    }
    return dataSourceDescription;
  }
}

abstract class PanoramaPlatformCallbacksHandler {
  // 图片加载完成。 0-失败   1-成功
  void onImageLoaded(int state);
}

/// 数据源类型
enum DataSourceType {
  /// asset资源
  asset,

  /// 网络资源
  network,

  /// 文件资源
  file
}

/// 数据源
class DataSource {
  DataSource({
    @required this.sourceType,
    this.uri,
    this.asset,
    this.package,
  });

  /// 资源类型
  final DataSourceType sourceType;

  /// 网络资源的URI
  final String uri;

  /// asset的路径
  final String asset;

  /// package仅用于加载asset资源时使用
  final String package;

  /// 转化成map
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
//    data['sourceType'] = this.sourceType.index;
    data['uri'] = this.uri;
    data['asset'] = this.asset;
    data['package'] = this.package;
    return data;
  }
}

enum ImageType {
  /// 启动标记
  MEDIA_START_MARKER,
  /// 单视图
  MEDIA_MONOSCOPIC,
  /// 上下视图
  MEDIA_STEREO_TOP_BOTTOM,
  /// 左右视图
  MEDIA_STEREO_LEFT_RIGHT
}