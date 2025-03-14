import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../reusable component/card_component.dart';
import '../admindrawer.dart';
import 'applied_applications/birth_certificates.dart';
import 'applied_applications/birthcertificaterequest.dart';

class applications extends StatefulWidget {
  const applications({super.key});

  @override
  State<StatefulWidget> createState() {
    return applicationsState();
  }
}

class applicationsState extends State {
  final List<Map<String, dynamic>> cardData = [
    {"title": "जन्म नोंदणी", "route": BirthCertificate()},
    {"title": "जन्माचा दाखला", "route": BirthCertificaterequest()},
    {"title": "मृत्यू प्रमाणपत्र", "route": ()},
    {"title": "विवाह प्रमाणपत्र", "route": ()},
    {"title": "8A उतारा", "route": ()},
    {"title": "निराधार दाखला", "route": ()},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("अर्ज", style: TextStyle(color: Colors.white)),
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two cards per row
            crossAxisSpacing: 10, // Horizontal spacing between cards
            mainAxisSpacing: 10, // Vertical spacing between cards
            childAspectRatio: 3 / 2, // Width to height ratio of each card
          ),
          itemCount: 6, // Number of cards
          itemBuilder: (context, index) {
            final data = cardData[index];
            return CustomCard(
              icon: data["icon"],
              title: data["title"],
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => data["route"],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
