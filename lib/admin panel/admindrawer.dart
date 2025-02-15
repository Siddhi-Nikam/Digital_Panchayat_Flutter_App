import 'package:digitalpanchayat/admin%20panel/admindashboard.dart';
import 'package:flutter/material.dart';
//import '../comman pages/buttons.dart';
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
                    radius: 40,
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
                  style: TextStyle(color: Colors.white, fontSize: 25),
                )
              ],
            ),
          ),
          ListTile(
            title: const Text('डॅशबोर्ड', style: TextStyle(fontSize: 20)),
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
            title: const Text('अर्ज', style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const applications()),
              );
            },
          ),
          ListTile(
            title: const Text('सूचना', style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const instructions()),
              );
            },
          ),
          ListTile(
            title: const Text('सेवा', style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const services()),
              );
            },
          ),
          ListTile(
            title: const Text('समस्या', style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const issues()),
              );
            },
          ),
          ListTile(
            title:
                const Text('घर कर आणि पाणी कर', style: TextStyle(fontSize: 20)),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PaidTax()),
              );
            },
          ),
          SizedBox(
            height: 100,
          ),
          ListTile(
            tileColor: Colors.blue,
            shape: Border.all(
                color: const Color.fromARGB(255, 75, 90, 97),
                strokeAlign: BorderSide.strokeAlignInside),
            leading: const Tooltip(
                message: "Logout",
                child: Icon(Icons.logout, color: Colors.white)),
            title: const Text(
              'लॉगआउट करा',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.pop(context);
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
