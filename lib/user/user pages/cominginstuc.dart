import 'package:digitalpanchayat/configs/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../outter pages/userdrawer.dart';

class UserInstruct extends StatefulWidget {
  final String token;
  const UserInstruct({super.key, required this.token});

  @override
  State<StatefulWidget> createState() {
    return UserInstructState();
  }
}

class UserInstructState extends State<UserInstruct> {
  late SharedPreferences prefs;
  final TextEditingController _searchController = TextEditingController();

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$BaseUrl/getInstruction'));

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
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "सूचना",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      drawer: AppDrawer(
        token: widget.token,
      ),
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
              scrollDirection: Axis.vertical,
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchData(),
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
                      scrollDirection: Axis.vertical,
                      reverse: true,
                      shrinkWrap: true,
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
                              Icons.arrow_forward,
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
                                        content: Text(data[index]['descp']),
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
                        color: Colors.grey,
                        thickness: 1,
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
