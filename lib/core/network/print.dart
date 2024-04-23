import 'package:flutter/services.dart';

class PrintHelper {
  static const MethodChannel _channel = MethodChannel('print_helper');

  static Future<void> printPDF(String filePath) async {
    try {
      await _channel.invokeMethod('printPDF', filePath);
    } on PlatformException catch (e) {
      print('Printing failed: ${e.message}');
    }
  }
}