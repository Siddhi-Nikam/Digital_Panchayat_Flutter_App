import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../reusable component/button.dart';
import '../../../reusable component/file_picking.dart';
import 'package:http/http.dart' as http;

class RegiBirth extends StatefulWidget {
  final String token;
  const RegiBirth({
    super.key,
    required this.token,
  });

  @override
  State<StatefulWidget> createState() {
    return RegiBirthState();
  }
}

class RegiBirthState extends State<RegiBirth> {
  late String uname;
  late String mob;
  @override
  void initState() {
    super.initState();

    // Decode JWT token and extract the necessary fields
    try {
      Map<String, dynamic> jwtdecodetoken = JwtDecoder.decode(widget.token);
      uname = jwtdecodetoken['uname'];
      mob = jwtdecodetoken['mob'];
    } catch (e) {
      print('Token format is invalid: $e');
    }
  }

  final Map<String, dynamic> _fileNames = {
    'applicantId': "No file selected",
    'LC': "No file selected",
    'fatherId': "No file selected",
    'motherId': "No file selected",
    'hospitalCertificate': "No file selected",
    'parentAffidavit': "No file selected",
  };
  FilePickerResult? result; // Make the result nullable

  // Function to pick a single file
  Future _pickFile(String key) async {
    result = await FilePicker.platform.pickFiles();

    if (result != null && result!.files.isNotEmpty) {
      PlatformFile file = result!.files.first;
      print("Selected file path: ${file.path}"); // Debugging: Log the file path

      setState(() {
        _fileNames[key] = file.path ?? "No file selected";
      });
    } else {
      setState(() {
        _fileNames[key] = "No file selected";
      });
    }
  }

  Future<void> _submitFiles() async {
    try {
      // API endpoint
      final url = Uri.parse("http://10.0.2.2:4000/registerbirth");

      // Prepare the request
      var request = http.MultipartRequest('POST', url);
      // Add form data fields
      request.fields['uname'] = uname;
      request.fields['mob'] = mob;

      // Add files to the request
      for (var entry in _fileNames.entries) {
        if (entry.value != "No file selected") {
          request.files.add(
            await http.MultipartFile.fromPath(entry.key, entry.value),
          );
        }
      }
      // Send the request
      var response = await request.send();

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content: Text("Successfully uploaded files"),
        ));

        print("Files uploaded successfully!");
      } else {
        print("Failed to upload files. Error: ${response.reasonPhrase}");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content: Text("Something went wrong "),
        ));
      }
    } catch (e) {
      print("Error while submitting files: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "जन्म नोंदणी",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "अर्जदाराचे नाव",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    enabled: false,
                    readOnly: true,
                    initialValue: uname,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: uname,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "अर्जदाराचा मोबाईल नंबर",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    readOnly: true,
                    enabled: false,
                    initialValue: mob,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      labelText: mob,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                //1
                Padding(padding: EdgeInsets.only(top: 10)),
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      "अर्जदाराचे ओळखपत्र",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                FilePickerRow(
                  fileName: _fileNames["applicantId"]!,
                  onPickFile: () {
                    _pickFile("applicantId");
                  },
                ),
                //2
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("शाळा सोडल्याचा दाखला ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                FilePickerRow(
                  fileName: _fileNames['LC']!,
                  onPickFile: () {
                    _pickFile("LC");
                  },
                ),
                //3
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("वडिलांचे ओळखपत्र",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                FilePickerRow(
                  fileName: _fileNames["fatherId"]!,
                  onPickFile: () {
                    _pickFile("fatherId");
                  },
                ),
                //4
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("आईचे ओळखपत्र",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                FilePickerRow(
                  fileName: _fileNames['motherId']!,
                  onPickFile: () {
                    _pickFile("motherId");
                  },
                ),
                //5
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("जन्म झालेल्या रुग्णालयाचे प्रमाणपत्र",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                FilePickerRow(
                  fileName: _fileNames['hospitalCertificate']!,
                  onPickFile: () {
                    _pickFile('hospitalCertificate');
                  },
                ),
                //6
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text("जन्म रुग्णालयात झाला नसल्यास पालकांचे शपथपत्र",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                  ),
                ),
                FilePickerRow(
                  fileName: _fileNames['parentAffidavit']!,
                  onPickFile: () {
                    _pickFile('parentAffidavit');
                  },
                ),

                btn(
                  text: 'सबमिट करा',
                  onPressed: () {
                    _submitFiles();
                  },
                  bg_color: Colors.blue,
                  textcolor: Colors.white,
                  fontSize: 25,
                ),
              ],
            ),
          ),
        ));
  }
}
