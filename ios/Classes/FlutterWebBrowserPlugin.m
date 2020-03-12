#import "FlutterWebBrowserPlugin.h"
#import <SafariServices/SafariServices.h>

@implementation FlutterWebBrowserPlugin 
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel methodChannelWithName:@"flutter_web_browser" binaryMessenger:[registrar messenger]];
  FlutterWebBrowserPlugin* instance = [[FlutterWebBrowserPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"openWebPage" isEqualToString:call.method]) {
        NSString *url = call.arguments[@"url"];
        NSString *barTint = call.arguments[@"ios_bar_tint_color"];
        NSString *controlTint = call.arguments[@"ios_control_tint_color"];
        
        NSURL *URL = [NSURL URLWithString:url];
        UIColor *barTintColor = nil;
        UIColor *controlTintColor = nil;

        if ( ( ![barTint isEqual:[NSNull null]] ) && ( [barTint length] != 0 ) ) {
            barTintColor = [self colorFromHexString:barTint];
        }
        
        if ( ( ![controlTint isEqual:[NSNull null]] ) && ( [controlTint length] != 0 ) ) {
            controlTintColor = [self colorFromHexString:controlTint];
        }
        
        UIViewController *viewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        if ( viewController.presentedViewController && !viewController.presentedViewController.isBeingDismissed ) {
            viewController = viewController.presentedViewController;
        }
        
        if (@available(iOS 10.0, *)) {
            SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:URL];
            
            if ( ( ![barTint isEqual:[NSNull null]] ) && ( [barTint length] != 0 ) ) {
                sfvc.preferredBarTintColor = barTintColor;
            }
            
            if ( ( ![controlTint isEqual:[NSNull null]] ) && ( [controlTint length] != 0 ) ) {
                sfvc.preferredControlTintColor = controlTintColor;
            }
            
            [viewController presentViewController:sfvc animated:YES completion:nil];
        } else if (@available(iOS 9.0, *)) {
            SFSafariViewController *sfvc = [[SFSafariViewController alloc] initWithURL:URL];
            
            if ( ( ![controlTintColor isEqual:[NSNull null]] ) && ( [controlTint length] != 0 ) ) {
                sfvc.view.tintColor = controlTintColor;
            }
            
            [viewController presentViewController:sfvc animated:YES completion:nil];
        } else {
            [[UIApplication sharedApplication] openURL:URL];
        }
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

- (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:3]; // bypass '#' character and leading FFs
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}


@end
