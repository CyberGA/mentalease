import 'dart:convert';

import 'package:crypto/crypto.dart' as crypto_hash;

enum CryptoAlg { md5, sha1, sha256, sha512 }

class Crypto {
  /// Hash Method
  static hash(String data) {
    final bytes = utf8.encode(data);

    final digest = crypto_hash.sha256.convert(bytes);

    final hash = digest.toString();
    return hash;
  }
}
