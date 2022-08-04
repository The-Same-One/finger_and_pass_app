import 'package:encrypt/encrypt.dart' as encrypt;

class MyEncryptionDecryption{
  static final key = encrypt.Key.fromLength(32);
  static final iv = encrypt.IV.fromLength(16);
  static String pass = "";

  static final encrypter = encrypt.Encrypter(encrypt.AES(key));
  static encryptAES(text){
    final enc = encrypter.encrypt(text, iv: iv);
    pass = enc.base64.toString();
    print(enc.bytes);
    print(enc.base16);
    print(enc.base64);
    print(pass);
    return enc;
  }
  static decryptAES(text){
    return encrypter.decrypt(text, iv: iv);
  }
}