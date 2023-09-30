// ignore_for_file: use_build_context_synchronously

import 'package:http/http.dart' as http;

Future<bool> isInternetAvailable() async {
  try {
    final response = await http.get(Uri.parse('https://www.google.com'));
    return response.statusCode == 200;
  } catch (e) {
    return false;
  }
}
