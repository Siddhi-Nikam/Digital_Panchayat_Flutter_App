import 'package:digitalpanchayat/configs/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../admindrawer.dart';

class issues extends StatefulWidget {
  final token;
  const issues({super.key, this.token});

  @override
  State<StatefulWidget> createState() {
    return issuesState();
  }
}

class issuesState extends State<issues> {
  late SharedPreferences prefs;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _issues = [];
  List<Color> _buttonColors = [];
  List<String> _buttonTexts = [];

  Future<void> loadIssues() async {
    try {
      final response = await http.get(Uri.parse('$BaseUrl/fetchIssue'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is Map && data.containsKey('data')) {
          setState(() {
            _issues = (data['data'] as List).cast<Map<String, dynamic>>();
            _buttonColors =
                List<Color>.filled(_issues.length, Colors.grey.shade200);
            _buttonTexts = List<String>.filled(_issues.length, "Pending");
          });
        }
      } else {
        throw Exception('Failed to load issues');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    loadIssues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text("समस्या", style: TextStyle(color: Colors.white)),
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    ),
                    prefixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {},
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),

            // Issue list
            _issues.isEmpty
                ? const Padding(
                    padding: EdgeInsets.only(top: 100),
                    child: Center(
                        child: CircularProgressIndicator(color: Colors.blue)),
                  )
                : ListView.separated(
                    reverse: true,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _issues.length,
                    itemBuilder: (context, index) {
                      final issue = _issues[index];
                      return ListTile(
                        leading: const Icon(
                          Icons.integration_instructions,
                          color: Colors.blue,
                        ),
                        title: Text(
                          issue['title'],
                          style: const TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text("More information.."),
                        trailing: SizedBox(
                          height: 40,
                          width: 140,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                _buttonColors[index] = Colors.green;
                                _buttonTexts[index] = "Completed";
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: _buttonColors[index],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              _buttonTexts[index],
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => AlertDialog(
                              title: Text(
                                issue['title'],
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              content: SizedBox(
                                height: 100,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      issue['descp'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 10),
                                    Text("Send By : ${issue['uname']}"),
                                    const SizedBox(height: 5),
                                    Text("Mobile Number : ${issue['mob']}"),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Close"),
                                )
                              ],
                            ),
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) =>
                        const Divider(color: Colors.grey, thickness: 1),
                  ),
          ],
        ),
      ),
    );
  }
}
