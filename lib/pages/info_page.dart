import 'package:flutter/material.dart';

class DevelopmentTeamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: const Text(
          "Nucleus Geliştirme Ekibi",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TeamMemberCard(
              name: 'Bahadır Tarık Alioğlu',
              role: 'Uygulama ve Elektronik Yazılımcısı',
              imagePath: 'assets/programmer.png', // Mimar için bir resim
            ),
            SizedBox(height: 16.0),
            TeamMemberCard(
              name: 'Bedirhan Şahin',
              role: 'Reaktör Mimarı',
              imagePath: 'assets/designer.png', // Tasarımcı için bir resim
            ),
            SizedBox(height: 16.0),
            TeamMemberCard(
              name: 'İsmail Hamza Küçük',
              role: 'Devre Tasarımcısı',
              imagePath: 'assets/engineer.png', // Yazılımcı için bir resim
            ),
          ],
        ),
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String imagePath;

  TeamMemberCard({
    required this.name,
    required this.role,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
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
      child: Row(
        children: [
          CircleAvatar(
            radius: 40.0,
            backgroundImage: AssetImage(imagePath),
          ),
          SizedBox(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                role,
                style: TextStyle(color: Colors.grey, fontSize: 11),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
