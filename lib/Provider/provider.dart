// ignore_for_file: unused_field, prefer_final_fields, avoid_print

import 'package:flutter/material.dart';

class ChangedMsg with ChangeNotifier {
  String _result = "not changed";
  String get result => _result;
  void changed() {
    print("Called");
    _result = "changed";
    notifyListeners();
  }

  void unchanged() {
    print("Called");
    _result = "unchanged";
    notifyListeners();
  }
}
