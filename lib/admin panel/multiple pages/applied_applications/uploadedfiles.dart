import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:digitalpanchayat/config.dart';

class ViewUploadedFiles extends StatefulWidget {
  final String uname;
  final String mob;

  const ViewUploadedFiles({
    super.key,
    required this.uname,
    required this.mob,
  });

  @override
  _ViewUploadedFilesState createState() => _ViewUploadedFilesState();
}

class _ViewUploadedFilesState extends State<ViewUploadedFiles> {
  List<dynamic>? uploadedFiles;
  late final String uname;
  late final String mob;

  Future<void> fetchUploadedFiles() async {
    try {
      final url = Uri.parse(
          "$BaseUrl/birthregister?uname=${widget.uname}&mob=${widget.mob}");
      final response = await http.get(url);

      //print("name & mob : $uname , $mob");

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        setState(() {
          uploadedFiles = responseData;
        });
      } else {
        print("Failed to fetch files: ${response.reasonPhrase}");
      }
    } catch (e) {
      print("Error fetching files: $e");
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
      appBar: AppBar(title: Text("Uploaded Files")),
      body: uploadedFiles == null
          ? Center(child: CircularProgressIndicator())
          : uploadedFiles!.isEmpty
              ? Center(child: Text("No files uploaded"))
              : ListView.builder(
                  itemCount: uploadedFiles!.length,
                  itemBuilder: (context, index) {
                    final file = uploadedFiles![index] as Map<String, dynamic>;
                    return ListTile(
                      title: Text(file['name'] ?? "no name found"),
                      subtitle: Text(file['path'] ?? "path is not found"),
                      trailing: Icon(Icons.download),
                      onTap: () {
                        // Implement file download
                      },
                    );
                  },
                ),
    );
  }
}
