import 'package:flutter/material.dart';

class EmergencyButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  EmergencyButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 36, vertical: 20),
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.red, // Buton metni rengi
          elevation: 8.0, // Gölgelendirme
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            text,
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      body: Center(
        child: EmergencyButton(
          text: 'Acil Durum',
          onPressed: () {
            // Acil durum butonuna basıldığında yapılacak işlemler
            print('Acil durum butonuna basıldı!');
          },
        ),
      ),
    ),
  ));
}
