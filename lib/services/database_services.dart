import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DatabaseServices {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('data');

  void updateData(var data, String key) {
    _databaseReference
        .update({key: data})
        .then((_) => debugPrint('Veri güncellendi'))
        .catchError((error) => debugPrint('Veri güncelleme hatası: $error'));
  }
}
