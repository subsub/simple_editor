#import "SimpleEditorPlugin.h"
#if __has_include(<simple_editor/simple_editor-Swift.h>)
#import <simple_editor/simple_editor-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "simple_editor-Swift.h"
#endif

@implementation SimpleEditorPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSimpleEditorPlugin registerWithRegistrar:registrar];
}
@end
