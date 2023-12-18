import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nucleus/components/cooling_motor_status.dart';
import 'package:nucleus/components/emergency_button.dart';
import 'package:nucleus/components/loading_indicator.dart';
import 'package:nucleus/components/natura_disaster_menu.dart';
import 'package:nucleus/components/reactor_status_card.dart';
import 'package:nucleus/services/database_services.dart';

class AlertPage extends StatefulWidget {
  const AlertPage({super.key});

  @override
  State<AlertPage> createState() => _AlertPageState();
}

class _AlertPageState extends State<AlertPage> {
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.reference().child('data');
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

            String state = data['state'];
            int motor = data['motor'];

            String stateText = state == "natural"
                ? "Stabil"
                : state == "quake"
                    ? "Deprem Algılandı"
                    : state == "flood"
                        ? "Sel Algılandı"
                        : state == "fire"
                            ? "Yangın Algılandı"
                            : state == "leak"
                                ? "Gaz Kaçağı Algılandı"
                                : state == "emergency"
                                    ? "Acil Durum"
                                    : "Veriye Erişilemiyor";

            debugPrint("Durum: $state");
            debugPrint("Motor: $motor");

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  ReactorStatusCard(reactorStatus: stateText),
                  CoolingMotorStatusCard(isWorking: motor == 1 ? true : false),
                  const SizedBox(
                    height: 6,
                  ),
                  NaturalDisasterMenu(),
                  const SizedBox(
                    height: 12,
                  ),
                  EmergencyButton(
                      text: "Acil Durum Butonu",
                      onPressed: () {
                        DatabaseServices().updateData("emergency", "state");
                      }),
                ],
              ),
            );
          }),
    );
  }
}
