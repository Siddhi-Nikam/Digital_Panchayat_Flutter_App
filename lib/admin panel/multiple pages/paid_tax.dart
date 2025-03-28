import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../configs/config.dart';
import '../admindrawer.dart';

class PaidTax extends StatefulWidget {
  const PaidTax({super.key});

  @override
  State<StatefulWidget> createState() {
    return PaidTaxState();
  }
}

class PaidTaxState extends State {
  final TextEditingController _searchController = TextEditingController();

  Future<List<Map<String, dynamic>>> paidataxes() async {
    try {
      final response = await http.get(Uri.parse('$BaseUrl/getPayment'));

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
        title: const Text("कर", style: TextStyle(color: Colors.white)),
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
            RefreshIndicator(
              onRefresh: paidataxes,
              color: Colors.blue,
              child: SingleChildScrollView(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: paidataxes(),
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
                              leading: CircleAvatar(
                                backgroundColor: Colors.blue,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.white,
                                ),
                              ),
                              title: Text(
                                data[index]['uname'],
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                'RS.${data[index]['amount']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              trailing: Text(
                                " ${data[index]['status']}",
                                style: TextStyle(
                                    color: Colors.green,
                                    //fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (context) => AlertDialog(
                                          title: Text(
                                            "Payment Information",
                                            style: const TextStyle(
                                              fontSize: 20,
                                              color: Colors.blue,
                                            ),
                                          ),
                                          content: SizedBox(
                                            height: 200,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Payment Status : ${data[index]['status']}",
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.green),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "Mobile Number :${data[index]['mob']}",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "Date of Payment: ${data[index]['createdAt'].split('T').first}",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                                SizedBox(height: 5),
                                                Text(
                                                  "Transaction Id : ${data[index]['payment_id']}",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
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
            ),
          ],
        ),
      ),
    );
  }
}
