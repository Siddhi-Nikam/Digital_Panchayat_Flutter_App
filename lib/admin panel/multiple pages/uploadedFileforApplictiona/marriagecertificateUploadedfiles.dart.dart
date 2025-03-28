import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import '../../../configs/config.dart';

class ViewUploadedFiles extends StatefulWidget {
  final String data;
  ViewUploadedFiles({super.key, required this.data});

  @override
  _ViewUploadedFilesState createState() => _ViewUploadedFilesState();
}

class _ViewUploadedFilesState extends State<ViewUploadedFiles> {
  List filenames = [
    'वर फोटो',
    "वधू फोटो",
    "वर चे आधार कार्ड",
    "वधू चे आधार कार्ड",
    "वरचा शाळा सोडल्याचा दाखला ",
    "वधूचा शाळा सोडल्याचा दाखला",
    " साक्षीदार 1 फोटो",
    "साक्षीदारचे आधार कार्ड",
    " साक्षीदार 2 फोटो ",
    "साक्षीदारचे आधार कार्ड",
    "साक्षीदार 3 फोटो",
    "साक्षीदारचे आधार कार्ड",
    "लग्नपत्रिका",
    "लग्नाचा ब्राह्मण सोबत फोटो",
    "विवाह नोंदणी अर्ज"
  ];
  List<Map<String, String>> uploadedFiles = [];
  bool isLoading = true;
  String errorMessage = "";
  late String applicationId = widget.data;

  Future<void> fetchUploadedFiles() async {
    try {
      final url =
          Uri.parse("$BaseUrl/getmarriageCertificateByAddedBy/$applicationId");
      final response = await http.get(url);

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final decodedResponse = jsonDecode(response.body);

        if (decodedResponse is Map && decodedResponse["status"] == true) {
          final List<dynamic> data = decodedResponse["data"];
          List<Map<String, String>> extractedFiles = [];

          for (var entry in data) {
            if (entry.containsKey("files") && entry["files"] is Map) {
              Map<String, dynamic> files = entry["files"];

              files.forEach((key, value) {
                // Convert Windows-style backslashes to forward slashes
                String filePath = value.replaceAll(r'\', '/');
                String fileUrl = "$BaseUrl/$filePath"
                    .replaceAll("//", "/"); // Fix double slashes

                extractedFiles.add({"name": key, "url": fileUrl});
              });
            }
          }

          setState(() {
            uploadedFiles = extractedFiles;
            isLoading = false;
          });
        } else {
          setState(() {
            errorMessage = "Invalid response format.";
            isLoading = false;
          });
        }
      } else {
        setState(() {
          errorMessage = "Failed to fetch files: ${response.reasonPhrase}";
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Error fetching files: $e";
        isLoading = false;
      });
    }
  }

  Future<void> _openFile(String fileUrl) async {
    final Uri url = Uri.parse(fileUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.inAppBrowserView);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open the file: $fileUrl")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUploadedFiles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            "Uploaded Files",
            style: TextStyle(color: Colors.white),
          )),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(
                  child: Text(errorMessage,
                      style: const TextStyle(color: Colors.red)))
              : uploadedFiles.isEmpty
                  ? const Center(child: Text("No files uploaded"))
                  : ListView.builder(
                      itemCount: uploadedFiles.length,
                      itemBuilder: (context, index) {
                        final file = uploadedFiles[index];
                        final fileUrl = file['url'] ?? "Url is Not found";

                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: ListTile(
                            leading: const Icon(
                              Icons.file_copy,
                              color: Colors.blue,
                            ),
                            title: Text(
                              index < filenames.length
                                  ? filenames[index]
                                  : "Uploaded File ${index + 1}",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              fileUrl.split('/').last,
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: const Icon(
                              Icons.download,
                              color: Colors.blue,
                            ),
                            onTap: fileUrl.isNotEmpty
                                ? () => _openFile(fileUrl)
                                : null,
                          ),
                        );
                      },
                    ),
    );
  }
}
