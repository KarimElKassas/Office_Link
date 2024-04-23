import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:foe_archiving/core/utils/prefs_helper.dart';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:shared_preferences/shared_preferences.dart';

class PDFEncryptionService {
  SharedPreferences prefs = Preference.prefs;

  static Future<void> encryptPDFInBackground(File pdfFile) async {
    final result = await compute(_encryptPDF, pdfFile);
    print('PDF encryption completed in the background.');
  }

  static Future<void> decryptPDFInBackground() async {
    final result = await compute(_decryptPDF, null);
    print('PDF decryption completed in the background.');
  }

  static Future<void> _encryptPDF(File pdfFile) async {
    // Generate a random encryption key
    final key = encrypt.Key.fromSecureRandom(32);

    // Generate a random initialization vector (IV)
    final iv = encrypt.IV.fromSecureRandom(16);

    // Get the PDF file bytes
    final pdfBytes = await pdfFile.readAsBytes();

    // Encrypt the PDF file bytes using the key and IV
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final encryptedBytes = encrypter.encryptBytes(pdfBytes, iv: iv);

    // Save the encrypted bytes and IV to a file
    final directory = await getApplicationDocumentsDirectory();
    final encryptedFile = File('${directory.path}/encrypted_file.pdf');
    await encryptedFile.writeAsBytes([iv.bytes, encryptedBytes.bytes].expand((e) => e).toList());

    // Store the encryption key and IV in shared preferences
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('encryption_key', base64.encode(key.bytes));
    prefs.setString('encryption_iv', base64.encode(iv.bytes));

    print('PDF encrypted and saved successfully.');
  }

  static Future<File> _decryptPDF(void _) async {
    // Retrieve the encryption key and IV from shared preferences
    final prefs = await SharedPreferences.getInstance();
    final encryptedKey = prefs.getString('encryption_key');
    final encryptedIV = prefs.getString('encryption_iv');
    if (encryptedKey == null || encryptedIV == null) {
      throw Exception('Encryption key or IV not found.');
    }

    // Decode the encryption key and IV
    final key = encrypt.Key.fromBase64(encryptedKey);
    final iv = encrypt.IV.fromBase64(encryptedIV);

    // Read the encrypted file bytes and IV
    final directory = await getApplicationDocumentsDirectory();
    final encryptedFile = File('${directory.path}/encrypted_file.pdf');
    final encryptedData = await encryptedFile.readAsBytes();

    // Split the encrypted data into IV and encrypted bytes
    final ivBytes = encryptedData.sublist(0, iv.bytes.length);
    final encryptedBytes = encryptedData.sublist(iv.bytes.length);

    // Decrypt the encrypted file bytes using the key and IV
    final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
    final decryptedBytes = encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes), iv: iv);

    // Save the decrypted bytes to a new file
    final decryptedFile = File('${directory.path}/decrypted_file.pdf');
    await decryptedFile.writeAsBytes(decryptedBytes);

    print('PDF decrypted and saved successfully.');
    return decryptedFile;
  }
}