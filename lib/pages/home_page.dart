import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:nucleus/components/info_card.dart';
import 'package:nucleus/components/loading_indicator.dart';
import 'package:nucleus/components/scientist_status_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

            var temperature = data['heat'];
            var humidity = data['damp'];
            var waterLevel = data['water'];
            var gasLevel = data['gas'];
            int scientist1 = data['user1'];
            int scientist2 = data['user2'];
            int scientist3 = data['user3'];

            debugPrint("Sıcaklık: $temperature");
            debugPrint("Nem: $humidity");
            debugPrint("Water: $waterLevel");
            debugPrint("Gaz: $gasLevel");

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(
                    height: 24,
                  ),
                  Expanded(
                    child: GridView(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                      ),
                      children: [
                        InfoCard(
                          dataType: 'Sıcaklık',
                          percentage: temperature,
                        ),
                        InfoCard(
                          dataType: 'Nem',
                          percentage: humidity,
                        ),
                        InfoCard(
                          dataType: 'Su Seviyesi',
                          percentage: waterLevel,
                        ),
                        InfoCard(
                          dataType: 'Partikül Miktarı',
                          percentage: gasLevel,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  ScientistStatusCard(
                    scientists: [
                      Scientist(
                          name: "Erwin Schrödinger",
                          inReactor: scientist1 == 1 ? true : false),
                      Scientist(
                          name: "Niels Bohr",
                          inReactor: scientist2 == 1 ? true : false),
                      Scientist(
                          name: "J. Robert Oppenheimer",
                          inReactor: scientist3 == 1 ? true : false),
                    ],
                  ),
                ],
              ),
            );
          }),
    );
  }
}
