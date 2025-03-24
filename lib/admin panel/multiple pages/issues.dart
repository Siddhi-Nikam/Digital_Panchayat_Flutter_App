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

class issuesState extends State {
  late SharedPreferences prefs;
  final TextEditingController _searchController = TextEditingController();

  Future<List<Map<String, dynamic>>> fetchIssues() async {
    try {
      final response = await http.get(Uri.parse('$BaseUrl/fetchIssue'));

      if (response.statusCode == 200) {
        print(response.statusCode);
        var data = jsonDecode(response.body);
        print(data);
        if (data is Map && data.containsKey('data')) {
          return (data['data'] as List).cast<Map<String, dynamic>>();
        } else {
          throw Exception("Unexpected response format");
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text("समस्या", style: TextStyle(color: Colors.white)),
      ),
      drawer: const AdminDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                // Add padding around the search bar
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                // Use a Material design search bar
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search...',
                    // Add a clear button to the search bar
                    suffixIcon: IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () => _searchController.clear(),
                    ),
                    // Add a search icon or button to the search bar
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        // Perform the search here
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchIssues(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: Colors.blue,
                    ));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final data = snapshot.data ?? [];
                    return ListView.separated(
                      reverse: true,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                            leading: const Icon(
                              Icons.integration_instructions,
                              color: Colors.blue,
                            ),
                            title: Text(
                              data[index]['title'],
                              style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text("More information.."),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.blue,
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                        title: Text(
                                          data[index]['title'],
                                          style: const TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        content: SizedBox(
                                          height: 100,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                data[index]['descp'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                  "Send By : ${data[index]['uname']}"),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  "Mobile Number : ${data[index]['mob']}")
                                            ],
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Close"))
                                        ],
                                      ));
                            });
                      },
                      separatorBuilder: (context, index) => const Divider(
                        color: Colors.grey, // Customize the divider color
                        thickness: 1, // Customize the divider thickness
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
