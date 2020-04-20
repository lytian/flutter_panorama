#import "FlutterPanoramaPlugin.h"
#if __has_include(<flutter_panorama/flutter_panorama-Swift.h>)
#import <flutter_panorama/flutter_panorama-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_panorama-Swift.h"
#endif

@implementation FlutterPanoramaPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterPanoramaPlugin registerWithRegistrar:registrar];
}
@end
