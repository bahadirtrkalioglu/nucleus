// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:nucleus/services/database_services.dart';

class NeumorphicButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const NeumorphicButton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ElevatedButton.styleFrom(
          primary: Colors.grey[200], // Butonun arkaplan rengi
          onPrimary: Colors.black, // Buton metni rengi
          elevation: 8.0, // Gölgelendirme
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.teal,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class NaturalDisasterMenu extends StatefulWidget {
  @override
  _NaturalDisasterMenuState createState() => _NaturalDisasterMenuState();
}

class _NaturalDisasterMenuState extends State<NaturalDisasterMenu> {
  String _selectedDisaster = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.white,
            offset: Offset(-8.0, -8.0),
            blurRadius: 16.0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(8.0, 8.0),
            blurRadius: 16.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Doğal Afet Seçimi',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          SizedBox(height: 16.0),
          DropdownButton<String>(
            value: _selectedDisaster,
            icon: const Icon(Icons.arrow_downward),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDisaster = newValue!;
              });
            },
            items: <String>['', 'Deprem', 'Yangın', 'Sel', 'Gaz Kaçağı']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          SizedBox(height: 32.0),
          NeumorphicButton(
            text: 'Test Et',
            onPressed: () {
              if (_selectedDisaster.isNotEmpty) {
                // Veritabanı işlemleri burada yapılabilir
                String disasterText = _selectedDisaster == "Deprem"
                    ? "quake"
                    : _selectedDisaster == "Sel"
                        ? "flood"
                        : _selectedDisaster == "Yangın"
                            ? "fire"
                            : _selectedDisaster == "Gaz Kaçağı"
                                ? "leak"
                                : "error";
                DatabaseServices().updateData(disasterText, "state");
                debugPrint('Seçilen Doğal Afet: $_selectedDisaster');
              } else {
                // Kullanıcıya bir uyarı verebilirsiniz
                DatabaseServices().updateData("natural", "state");
              }
            },
          ),
        ],
      ),
    );
  }
}
