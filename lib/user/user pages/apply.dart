import 'package:flutter/material.dart';
import '../outter pages/userdrawer.dart';
import 'applications pages/birth.certificate.dart';
import 'applications pages/death_regi.dart';
import 'applications pages/marriage.regi.dart';
import 'applications pages/regi_birth.dart';

class Apply extends StatefulWidget {
  final String token;
  const Apply({required this.token, super.key});

  @override
  State<Apply> createState() {
    return ApplyState();
  }
}

class ApplyState extends State<Apply> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "अर्ज",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(
        token: widget.token, // Accessing token here from widget
      ),
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(
              Icons.edit_document,
              color: Colors.blueAccent,
            ),
            title: const Text("जन्म नोंदणी"),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RegiBirth(token: widget.token)));
            },
          ),
          const Divider(
            height: 1,
          ),
          ListTile(
            leading: const Icon(
              Icons.edit_document,
              color: Colors.blueAccent,
            ),
            title: const Text("जन्माचा दाखला"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => BirthCertificate()));
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(
              Icons.edit_document,
              color: Colors.blueAccent,
            ),
            title: const Text("मृत्यू प्रमाणपत्र"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => DeathRegi()));
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(
              Icons.edit_document,
              color: Colors.blueAccent,
            ),
            title: const Text("विवाह प्रमाणपत्र"),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Marriage_regi()));
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(
              Icons.edit_document,
              color: Colors.blueAccent,
            ),
            title: const Text("दारिद्र्यरेषेखालील असल्याचा पुरावा"),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(
              Icons.edit_document,
              color: Colors.blueAccent,
            ),
            title: const Text("8A उतारा"),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(
              Icons.edit_document,
              color: Colors.blueAccent,
            ),
            title: const Text("निराधार पुरावा"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
