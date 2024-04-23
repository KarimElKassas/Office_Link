import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'dart:math';

class EncryptionService {
  static encrypt.Key generateRandomKey(int keyLength) {
    final random = Random.secure();
    List<int> bytes = List.generate(keyLength ~/ 8, (index) => random.nextInt(256));
    return encrypt.Key(Uint8List.fromList(bytes));
  }

  static Future<void> encryptAndSavePDF(File pdfFile, int keyLength) async {
    final Uint8List pdfBytes = await pdfFile.readAsBytes();
    final key = generateRandomKey(keyLength);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final encryptedPDF = encrypter.encryptBytes(pdfBytes);

    final directory = await getApplicationDocumentsDirectory();
    final encryptedFile = File('${directory.path}/encrypted_file.pdf');
    await encryptedFile.writeAsBytes(encryptedPDF.bytes);

    print('PDF encrypted and saved successfully.');
  }

  static Future<File> decryptPDF(String encryptedFilePath, int keyLength) async {
    final encryptedFile = File(encryptedFilePath);
    final Uint8List encryptedBytes = await encryptedFile.readAsBytes();
    final key = generateRandomKey(keyLength);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));

    final decryptedPDF = encrypter.decryptBytes(encrypt.Encrypted(encryptedBytes));

    final directory = await getApplicationDocumentsDirectory();
    final decryptedFile = File('${directory.path}/decrypted_file.pdf');
    await decryptedFile.writeAsBytes(decryptedPDF);

    print('PDF decrypted and saved successfully.');
    return decryptedFile;
  }
}
