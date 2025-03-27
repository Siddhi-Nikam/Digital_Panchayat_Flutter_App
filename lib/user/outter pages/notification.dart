import 'package:digitalpanchayat/user/outter%20pages/userdrawer.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatefulWidget {
  final String token;
  final Map data;

  const NotificationPage({super.key, required this.token, required this.data});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    // Get arguments passed from notification
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    // Extract title and body from arguments
    String title = args?['title'] ?? 'No Title';
    String body = args?['body'] ?? 'No Body';

    return Scaffold(
      drawer: AppDrawer(token: widget.token),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.blue,
        title: const Text(
          'Notifications',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: args == null
          ? Center(
              child: Text("Empty Notification"),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(
                      Icons.notifications,
                      color: Colors.blue,
                      size: 30,
                    ),
                    title: Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    subtitle: Text(
                      body,
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
