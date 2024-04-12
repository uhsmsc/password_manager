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
  // Получаем ключ шифрования
  final key = await generateEncryptionKey();

  // Генерируем случайный вектор инициализации (IV)
  final iv = encrypt.IV.fromSecureRandom(16); // 16 байт для AES

  // Создаем экземпляр шифратора AES с полученным ключом и IV
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

  // Преобразуем пароль в Uint8List
  final Uint8List passwordBytes = Uint8List.fromList(password.codeUnits);

  // Шифруем пароль
  final encryptedPassword = encrypter.encryptBytes(passwordBytes, iv: iv);

  // Возвращаем зашифрованный пароль в виде строки и строку с IV
  return {
    'encryptedPassword': encryptedPassword.base64,
    'iv': iv.base64,
  };
}

Future<String?> decryptPassword(
    String encryptedPassword, String ivString) async {
  if (encryptedPassword.isNotEmpty && ivString.isNotEmpty) {
    // Получаем ключ шифрования
    final key = await generateEncryptionKey();

    // Создаем экземпляр шифратора AES с полученным ключом
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    // Декодируем IV из строки
    final iv = encrypt.IV.fromBase64(ivString);

    // Декодируем строку в байтовый массив
    final Uint8List encryptedBytes = base64.decode(encryptedPassword);

    // Расшифровываем пароль
    final decryptedBytes = encrypter.decryptBytes(
      encrypt.Encrypted(encryptedBytes),
      iv: iv, // Передаем IV для расшифровки
    );

    // Преобразуем байтовый массив обратно в строку
    final decryptedPassword = utf8.decode(decryptedBytes);

    return decryptedPassword;
  } else {
    return null; // Возвращаем null, если зашифрованный пароль или IV пустые
  }
}
