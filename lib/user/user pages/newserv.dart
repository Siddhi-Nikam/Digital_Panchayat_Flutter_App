import 'dart:convert';
import 'package:digitalpanchayat/configs/config.dart';
import 'package:digitalpanchayat/user/outter%20pages/userdrawer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Service extends StatefulWidget {
  final String token;
  const Service({required this.token, super.key});

  @override
  State<StatefulWidget> createState() {
    return _ServiceState();
  }
}

class _ServiceState extends State<Service> {
  final TextEditingController _searchController = TextEditingController();

  Future<List<Map<String, dynamic>>> fetchData() async {
    try {
      final response = await http.get(Uri.parse('$BaseUrl/fetchService'));

      if (response.statusCode == 200) {
        print(response.statusCode);
        var data = jsonDecode(response.body);
        print(data);
        if (data is Map && data.containsKey('serviceData')) {
          return (data['serviceData'] as List).cast<Map<String, dynamic>>();
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
        title: const Text(
          "सेवा",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(
        token: widget.token,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
