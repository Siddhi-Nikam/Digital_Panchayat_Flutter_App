import 'package:digitalpanchayat/user/logout.dart';
import 'package:digitalpanchayat/user/outter%20pages/notification.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../user pages/addedfam.dart';
import '../user pages/addfam.dart';
import '../user pages/apply.dart';
import '../user pages/cominginstuc.dart';
import '../user pages/newserv.dart';
import '../user pages/sendissue.dart';
import '../user pages/tax pages/tax.dart';
import 'userdashboard.dart';

class AppDrawer extends StatefulWidget {
  final String token;
  const AppDrawer({super.key, required this.token});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  late String uname = 'User'; // Provide a default value

  @override
  void initState() {
    super.initState();
    // Decode JWT token and extract the necessary fields
    try {
      Map<String, dynamic> jwtdecodetoken = JwtDecoder.decode(widget.token);
      uname = jwtdecodetoken['uname'] ??
          'User'; // Fallback to default if 'uname' is null
    } catch (e) {
      print('Token format is invalid: $e');
    }
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
            leading: const Icon(Icons.home, color: Colors.blue),
            title: const Text(
              'डॅशबोर्ड',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.push(
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
            title: const Text(
              'अर्ज करा',
              style: TextStyle(fontSize: 20),
            ),
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
            title: const Text(
              'येणाऱ्या सूचना',
              style: TextStyle(fontSize: 20),
            ),
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
            title: const Text(
              'सेवा',
              style: TextStyle(fontSize: 20),
            ),
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
            title: const Text(
              'घरपट्टी आणि पाणी पट्टी',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => PaymentPage(
                          token: widget.token,
                        )),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.report, color: Colors.blue),
            title: const Text(
              'समस्या',
              style: TextStyle(fontSize: 20),
            ),
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
            title: const Text(
              'तुमचे कुटुंब सदस्य जोडा',
              style: TextStyle(fontSize: 20),
            ),
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
          ListTile(
            leading: const Icon(Icons.notifications, color: Colors.blue),
            title: const Text(
              'Notifications',
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationPage(
                    token: widget.token,
                    data: {},
                  ),
                ),
              );
            },
          ),
          SizedBox(
            height: 60,
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
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
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
