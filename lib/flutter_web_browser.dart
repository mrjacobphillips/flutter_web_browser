import 'dart:async';
import 'package:flutter/services.dart';

class FlutterWebBrowser {
  static MethodChannel _channel = MethodChannel('flutter_web_browser');

  static Future<dynamic> openWebPage({url, androidToolbarColor, iOSBarTintColor, iOSControlTintColor}) {
    var androidToolbarHexColor, iOSBarHexColor, iOSControlHexColor;

    if (androidToolbarColor != null) {androidToolbarHexColor = '#' + androidToolbarColor.value.toRadixString(16).padLeft(8, '0');}
    if (iOSBarTintColor != null) {iOSBarHexColor = '#' + iOSBarTintColor.value.toRadixString(16).padLeft(8, '0');}
    if (iOSControlTintColor != null) {iOSControlHexColor = '#' + iOSControlTintColor.value.toRadixString(16).padLeft(8, '0');}

    return _channel.invokeMethod('openWebPage', {
      "url": url,
      "android_toolbar_color": androidToolbarHexColor,
      "ios_bar_tint_color": iOSBarHexColor,
      "ios_control_tint_color": iOSControlHexColor,
    });
  }
}
