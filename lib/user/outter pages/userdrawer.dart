//import 'package:digitalpanchayat/comman%20pages/buttons.dart';
import 'package:digitalpanchayat/user/logout.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../user pages/addedfam.dart';
import '../user pages/addfam.dart';
import '../user pages/apply.dart';
import '../user pages/cominginstuc.dart';
import '../user pages/newserv.dart';
import '../user pages/sendissue.dart';
import '../user pages/tax.dart';
import 'userdashboard.dart';

class AppDrawer extends StatefulWidget {
  final String token;
  const AppDrawer({super.key, required this.token});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late String uname = "";

  @override
  void initState() {
    super.initState();
    // Decode JWT token and extract the necessary fields
    Map<String, dynamic> jwtdecodetoken = JwtDecoder.decode(widget.token);
    uname = jwtdecodetoken['uname'];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: const EdgeInsets.only(top: 50, left: 20),
            decoration: const BoxDecoration(color: Colors.blue),
            child: Text(
              "Welcome \n$uname",
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard, color: Colors.blue),
            title: const Text('डॅशबोर्ड'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => userdashboard(
                          token: widget.token,
                        )),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_document, color: Colors.blue),
            title: const Text('अर्ज करा'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Apply(
                          token: widget.token,
                        )),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.integration_instructions, color: Colors.blue),
            title: const Text('येणाऱ्या सूचना'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => UserInstruct(token: widget.token)),
              );
            },
          ),
          ListTile(
            leading:
                const Icon(Icons.miscellaneous_services, color: Colors.blue),
            title: const Text('सेवा'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Service(
                          token: widget.token,
                        )),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.money, color: Colors.blue),
            title: const Text('घरपट्टी आणि पाणी पट्टी'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => Tax(token: widget.token)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.report, color: Colors.blue),
            title: const Text('समस्या'),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => issue(token: widget.token),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.add, color: Colors.blue),
            title: const Text('तुमचे कुटुंब सदस्य जोडा'),
            trailing: IconButton(
                onPressed: () {
                  Navigator.pop(context); // Close the drawer
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FamList(token: widget.token),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.blue,
                )),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => addfam(token: widget.token),
                ),
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
              logout(context);
            },
          ),
        ],
      ),
    );
  }
}
