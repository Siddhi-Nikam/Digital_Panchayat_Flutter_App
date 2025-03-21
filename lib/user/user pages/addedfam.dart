import 'dart:convert';
import 'package:digitalpanchayat/configs/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../outter pages/userdrawer.dart';

class FamList extends StatefulWidget {
  final String token;
  const FamList({super.key, required this.token});

  @override
  State<FamList> createState() {
    return _FamListState();
  }
}

class _FamListState extends State<FamList> {
  final List family = [];
  late String addedBy;

  @override
  void initState() {
    super.initState();
    try {
      Map<String, dynamic> jwtdecodetoken = JwtDecoder.decode(widget.token);
      addedBy = jwtdecodetoken['adhar'];
      print(addedBy);
    } catch (e) {
      print('Token format is invalid: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getFam() async {
    try {
      final response = await http.get(
        Uri.parse('$BaseUrl/getfamilyByAddedBy/$addedBy'),
      );

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
      drawer:
          AppDrawer(token: widget.token), // Accessing token with widget.token
      appBar: AppBar(
        title: const Text(
          'Family List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: getFam(),
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
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.blue,
                    size: 50,
                  ),
                  title: Text(
                    data[index]['name'],
                    style: const TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                      'Adhar: ${data[index]["adhar"]} \n Gender: ${data[index]["gender"]} \n Date of birth: ${data[index]["DOB"]}'),
                );
              },
              separatorBuilder: (context, index) => const Divider(
                color: Colors.grey, // Customize the divider color
                thickness: 1, // Customize the divider thickness
              ),
            );
          }
        },
      ),
    );
  }
}
