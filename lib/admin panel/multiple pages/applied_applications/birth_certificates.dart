import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../config.dart';

class BirthCertificate extends StatefulWidget {
  const BirthCertificate({super.key});

  @override
  _BirthCertificateState createState() => _BirthCertificateState();
}

class _BirthCertificateState extends State<BirthCertificate> {
  late Future<List<Map<String, dynamic>>> _futureCertificates;
  late List<Map<String, dynamic>> data;
  @override
  void initState() {
    super.initState();
    _futureCertificates = fetchBirthCertificates();
  }

  Future<List<Map<String, dynamic>>> fetchBirthCertificates() async {
    try {
      final response = await http.get(Uri.parse('$BaseUrl/birthregister'));
      print(response.statusCode);

      if (response.statusCode == 200) {
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
        title: const Text('Birth Certificates',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _futureCertificates,
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
              if (data.isEmpty) {
                return const Center(
                    child: Text(
                  'No Birth Certificates Found',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ));
              }
              return ListView.separated(
                reverse: true,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const Icon(
                      Icons.integration_instructions,
                      color: Colors.blue,
                    ),
                    title: Text(
                      data[index]['uname'],
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      data[index]['mob'],
                      style: const TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward,
                      color: Colors.blue,
                    ),
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
      ),
    );
  }
}
