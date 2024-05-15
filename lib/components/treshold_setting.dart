// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class NeumorphicThresholdSettingWidget extends StatefulWidget {
  final String title;
  final int initialValue;
  final ValueChanged<int> onChanged;

  const NeumorphicThresholdSettingWidget({
    super.key,
    required this.title,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  _NeumorphicThresholdSettingWidgetState createState() =>
      _NeumorphicThresholdSettingWidgetState();
}

class _NeumorphicThresholdSettingWidgetState
    extends State<NeumorphicThresholdSettingWidget> {
  late int _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.initialValue;
  }

  void _handleButtonPress() {
    // Butona basıldığında yapılacak işlemler
    widget.onChanged(_sliderValue);

    // Veri tabanına istek atma işlemleri burada yapılabilir
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-8.0, -8.0),
            blurRadius: 16.0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: const Offset(8.0, 8.0),
            blurRadius: 16.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Eşik Değeri: $_sliderValue'),
              const SizedBox(width: 16.0),
              Expanded(
                child: Slider(
                  activeColor: Colors.teal,
                  value: _sliderValue.toDouble(),
                  min: 0.0,
                  max: 100.0,
                  divisions: 100,
                  onChanged: (value) {
                    setState(() {
                      _sliderValue = value.round();
                    });
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 4.0),
          ElevatedButton(
            onPressed: _handleButtonPress,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.black,
              backgroundColor: Colors.grey[300], // Buton metni rengi
              elevation: 6.0, // Gölgelendirme
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Değeri Kaydet',
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.blueGrey.shade800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
