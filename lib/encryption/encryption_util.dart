import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

Future<encrypt.Key> generateEncryptionKey() async {
  const storage = FlutterSecureStorage();
  final encryptedMasterPassword = await storage.read(key: 'master_password');
  if (encryptedMasterPassword == null) {
    throw Exception('Master password not found!');
  }

  // Преобразовать зашифрованный мастер-пароль в последовательность байтов
  final encryptedMasterPasswordBytes = utf8.encode(encryptedMasterPassword);

  // Вычислить хэш SHA-256 от зашифрованного мастер-пароля
  final hashBytes = sha256.convert(encryptedMasterPasswordBytes).bytes;

  // Преобразовать хэш в Uint8List
  final uint8ListKey = Uint8List.fromList(hashBytes);

  // Преобразовать Uint8List в ключ типа Key
  return encrypt.Key(uint8ListKey);
}

Future<Map<String, String>> encryptPassword(String password) async {
  final key = await generateEncryptionKey();
  final iv = encrypt.IV.fromSecureRandom(16);
  
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final Uint8List passwordBytes = Uint8List.fromList(password.codeUnits);

  final encryptedPassword = encrypter.encryptBytes(passwordBytes, iv: iv);

  return {
    'encryptedPassword': encryptedPassword.base64,
    'iv': iv.base64,
  };
}

Future<String?> decryptPassword(
    String encryptedPassword, String ivString) async {
  if (encryptedPassword.isNotEmpty && ivString.isNotEmpty) {
    final key = await generateEncryptionKey();
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));


    final iv = encrypt.IV.fromBase64(ivString);

    final Uint8List encryptedBytes = base64.decode(encryptedPassword);

    final decryptedBytes = encrypter.decryptBytes(
      encrypt.Encrypted(encryptedBytes),
      iv: iv,
    );

    final decryptedPassword = utf8.decode(decryptedBytes);

    return decryptedPassword;
  } else {
    return null;
  }
}

class EncryptionUtil {
  static const storage = FlutterSecureStorage();

  static Future<void> saveIVForAccount(String accountId, String iv) async {
    await storage.write(key: '${accountId}_iv', value: iv);
  }

  static Future<String?> getIVForAccount(String accountId) async {
    return await storage.read(key: '${accountId}_iv');
  }

  static Future<void> deleteIVForAccount(String accountId) async {
    await storage.delete(key: '${accountId}_iv');
  }
}

