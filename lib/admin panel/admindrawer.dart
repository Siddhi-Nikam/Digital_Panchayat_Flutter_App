import 'package:digitalpanchayat/admin%20panel/admindashboard.dart';
import 'package:flutter/material.dart';
import '../comman pages/buttons.dart';
import 'multiple pages/applications.dart';
import 'multiple pages/instruction.dart';
import 'multiple pages/issues.dart';
import 'multiple pages/services.dart';
import 'paid_tax.dart';

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.blue),
            child: Column(
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Icon(
                      Icons.person,
                      color: Colors.grey.shade800,
                      size: 50,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "प्रशासक",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )
              ],
            ),
          ),
          ListTile(
            title: const Text('डॅशबोर्ड'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const admindashboard(
                          token: null,
                        )),
              );
            },
          ),
          ListTile(
            title: const Text('अर्ज'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const applications()),
              );
            },
          ),
          ListTile(
            title: const Text('सूचना'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const instructions()),
              );
            },
          ),
          ListTile(
            title: const Text('सेवा'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const services()),
              );
            },
          ),
          ListTile(
            title: const Text('समस्या'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const issues()),
              );
            },
          ),
          ListTile(
            title: const Text('घर कर आणि पाणी कर'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PaidTax()),
              );
            },
          ),
          ListTile(
            title: const Text('लॉगआउट करा'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const buttons()),
              );
            },
          ),
        ],
      ),
    );
  }
}
