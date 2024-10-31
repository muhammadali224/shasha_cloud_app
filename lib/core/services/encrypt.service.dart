import 'package:encrypt/encrypt.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EncryptData {
  static final String _key = dotenv.env["ENCRYPT_KEY"]!;

  static Encrypted _encryptWithAES(String plainText) {
    final cipherKey = Key.fromUtf8(_key);
    final encryptService = Encrypter(AES(cipherKey, mode: AESMode.cbc));
    final initVector = IV.fromUtf8(_key.substring(0, 16));
    Encrypted encryptedData = encryptService.encrypt(plainText, iv: initVector);
    return encryptedData;
  }

  static String decryptText(String encryptedText) {
    final key = Key.fromUtf8(_key);
    final initVector = IV.fromUtf8(_key.substring(0, 16));
    final encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    final decrypted = encrypter.decrypt64(encryptedText, iv: initVector);
    return decrypted;
  }

  String generateEncryptQRCode({required String userId, required String id}) {
    String planText = "$id|$userId";
    Encrypted encrypted = _encryptWithAES(planText);
    String encryptedData = encrypted.base64;

    return encryptedData;
  }
}
