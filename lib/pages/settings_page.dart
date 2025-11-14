import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nucleus/components/loading_indicator.dart';
import 'package:nucleus/components/treshold_setting.dart';
import 'package:nucleus/services/database_services.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref().child('data');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: _databaseReference.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingIndicator();
            }
            DataSnapshot dataSnapshot = snapshot.data!.snapshot;
            var data = dataSnapshot.value as Map;

            int heatTresh = data['theat'];
            int gasTresh = data['tgas'];
            int waterTresh = data['twater'];

            debugPrint("Sıcaklık Eşik: $heatTresh");
            debugPrint("Partikül Eşik: $gasTresh");
            debugPrint("Su Eşik: $waterTresh");
            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Text(
                    "Eşik Değeri Ayarları",
                    style: TextStyle(
                      color: Colors.teal.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  NeumorphicThresholdSettingWidget(
                    title: "Sıcaklık",
                    initialValue: heatTresh,
                    onChanged: (value) {
                      debugPrint("Changed: $value");
                      DatabaseServices().updateData(value, "theat");
                    },
                  ),
                  NeumorphicThresholdSettingWidget(
                    title: "Su Seviyesi",
                    initialValue: waterTresh,
                    onChanged: (value) {
                      debugPrint("Changed: $value");
                      DatabaseServices().updateData(value, "twater");
                    },
                  ),
                  NeumorphicThresholdSettingWidget(
                    title: "Partikül Miktarı",
                    initialValue: gasTresh,
                    onChanged: (value) {
                      debugPrint("Changed: $value");
                      DatabaseServices().updateData(value, "tgas");
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }
}
