import 'dart:convert';

import 'package:crypto/crypto.dart';

String calculateMD5(String input) {
  var bytes = utf8.encode(input); // Encode the input string as bytes
  var md5Hash = md5.convert(bytes); // Calculate the MD5 hash
  return md5Hash.toString(); // Convert the hash to a string
}
