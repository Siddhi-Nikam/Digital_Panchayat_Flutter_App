import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../configs/config.dart';
import '../uploadedFileforApplictiona/BirthCertificateUploadedfiles.dart';

class BirthCertificaterequest extends StatefulWidget {
  const BirthCertificaterequest({super.key});

  @override
  _BirthCertificatereqestState createState() => _BirthCertificatereqestState();
}

class _BirthCertificatereqestState extends State<BirthCertificaterequest> {
  late Future<List<Map<String, dynamic>>> _futureCertificates;

  @override
  void initState() {
    super.initState();
    _futureCertificates = fetchBirthCertificatesrequest();
  }

  Future<List<Map<String, dynamic>>> fetchBirthCertificatesrequest() async {
    try {
      final response =
          await http.get(Uri.parse('$BaseUrl/getbirthCertificate'));
      //print('Response Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        var decodedData = jsonDecode(response.body);
        print('Decoded Data: $decodedData');

        if (decodedData is List) {
          return decodedData
              .cast<Map<String, dynamic>>(); // If API directly returns a list
        } else if (decodedData is Map && decodedData.containsKey('data')) {
          return (decodedData['data'] as List).cast<Map<String, dynamic>>();
        } else {
          throw Exception(
              "Unexpected response format: $decodedData"); // Print actual response
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
        title: const Text('Birth Certificates Requests',
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
                      Icons.edit_document,
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
                      Icons.arrow_forward_ios,
                      color: Colors.blue,
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Birthcertificateuploadedfiles(
                            data: data[index]['addedBy'],
                          ),
                        ),
                      );
                    },
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
