import 'dart:convert';
import 'dart:isolate';
import 'dart:io';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


Future<void> encryptPDFInBackground(dynamic message) async {
  final List<dynamic> args = message as List<dynamic>;
  BackgroundIsolateBinaryMessenger.ensureInitialized(args[0]);
  final String filePath = args[1];
  final SendPort sendPort = args[2];

  final prefs = await SharedPreferences.getInstance();

  // Check if encryption key and IV exist in SharedPreferences
  final encryptedKey = prefs.getString('encryption_key');
  final encryptedIV = prefs.getString('encryption_iv');

  encrypt.Key? key;
  encrypt.IV? iv;

  if (encryptedKey != null && encryptedIV != null) {
    key = encrypt.Key(base64.decode(encryptedKey));
    iv = encrypt.IV(base64.decode(encryptedIV));
  } else {
    key = encrypt.Key.fromSecureRandom(32);
    iv = encrypt.IV.fromSecureRandom(16);
    prefs.setString('encryption_key', base64.encode(key.bytes));
    prefs.setString('encryption_iv', base64.encode(iv.bytes));
  }

  final pdfBytes = File(filePath).readAsBytesSync();
  final encrypter = encrypt.Encrypter(encrypt.AES(key));
  final encrypted = encrypter.encryptBytes(pdfBytes,iv: iv);

  final encryptedData = {'iv': iv.bytes, 'encryptedBytes': encrypted.bytes};

  final directory = await getApplicationDocumentsDirectory();
  final encryptedFile = File('${directory.path}/encrypted_file.aes');
  encryptedFile.writeAsBytesSync(encrypted.bytes);

  sendPort.send(encryptedData);
}
Future<void> decryptPDFInBackground(dynamic message) async {
  final List<dynamic> args = message as List<dynamic>;
  BackgroundIsolateBinaryMessenger.ensureInitialized(args[0]);
  final String encryptedFilePath = args[1];
  final SendPort sendPort = args[2];

  final prefs = await SharedPreferences.getInstance();

  // Check if encryption key and IV exist in SharedPreferences
  final encryptedKey = prefs.getString('encryption_key');
  final encryptedIV = prefs.getString('encryption_iv');

  if (encryptedKey != null && encryptedIV != null) {
    final encrypt.Key key = encrypt.Key(base64.decode(encryptedKey));
    final encrypt.IV iv = encrypt.IV(base64.decode(encryptedIV));

    final encrypt.Encrypter encrypter = encrypt.Encrypter(encrypt.AES(key));
    Uint8List encryptedBytes = File(encryptedFilePath).readAsBytesSync();
    final decrypted = encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv); // Manual IV parameter

    final directory = await getApplicationDocumentsDirectory();
    final decryptedFile = File('${directory.path}/decrypted_file.pdf');
    decryptedFile.writeAsBytesSync(decrypted);
    sendPort.send("MESSAGE FROM DECRYPT !");
  } else {
    print('Error: Encryption key or IV not found in SharedPreferences.');
    // Handle the error or missing data scenario as needed
  }
}