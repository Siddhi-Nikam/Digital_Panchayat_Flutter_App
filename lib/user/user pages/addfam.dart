import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:http/http.dart' as http;
import '../../configs/config.dart';
import '../outter pages/userdrawer.dart';
import 'addedfam.dart';
//import 'package:shared_preferences/shared_preferences.dart';

class addfam extends StatefulWidget {
  final String token;
  const addfam({super.key, required this.token});

  @override
  State<StatefulWidget> createState() {
    return addfamState();
  }
}

class addfamState extends State<addfam> {
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

  final _nametext = TextEditingController();
  final _phone = TextEditingController();
  final adhar_controller = TextEditingController();
  final _DOB = TextEditingController();
  String? _selectedGender;

  final List<String> _genders = ['Male', 'Female', 'Other'];

  bool _obscureText = true;

  void showhide() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void showSuccessToast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text("Added successfully"),
    ));
  }

  void showerrortoast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text("Something went wrong"),
    ));
  }

  Future<dynamic> addFamily() async {
    try {
      if (_nametext.text.isNotEmpty &&
          _phone.text.isNotEmpty &&
          _selectedDate.toString().isNotEmpty &&
          _selectedGender.toString().isNotEmpty) {
        var regbody = {
          "addedBy": addedBy,
          "name": _nametext.text,
          "mob": _phone.text,
          "adhar": adhar_controller.text,
          "DOB": _selectedDate.toString(),
          "gender": _selectedGender.toString(),
        };

        var response = await http.post(
          Uri.parse("$BaseUrl/addfamily"),
          headers: {
            "Content-Type": "application/json",
          },
          body: jsonEncode(regbody),
        );
        print(jsonEncode(regbody));
        //print(response);

        if (response.statusCode == 200) {
          // Registration successful
          print('Family member added successfully');
          showSuccessToast();
          return json.decode(response.body);
        } else {
          // Registration failed
          showerrortoast();
          print('Failed to added: ${response.body}');
        }
      }
    } catch (e) {
      print('failed to load: $e');
    }
  }

  String? validateMobile(String? value) {
    // Remove any spaces or formatting
    String cleanedValue = value?.replaceAll(RegExp(r'\s+'), '') ?? '';
    if (cleanedValue.length != 10 ||
        !RegExp(r'^\d{10}$').hasMatch(cleanedValue)) {
      return "Enter a valid mobile number";
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(token: widget.token),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          "Add Your Family Member",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: _nametext,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Name cannot be empty";
                  }
                  // Allow letters, spaces, hyphens, and apostrophes
                  if (!RegExp(r"^[a-zA-Z\s'-]+$").hasMatch(value)) {
                    return "Only letters, spaces, hyphens, and apostrophes are allowed";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "पूर्ण नाव एंटर करा",
                  labelText: "पूर्ण नाव",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      )),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: _phone,
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: "##### #####",
                    filter: {"#": RegExp(r'[0-9]')},
                  ),
                ],
                validator: validateMobile,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "मोबाईल नंबर टाका",
                  labelText: "मोबाईल नंबर",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      )),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: adhar_controller,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  MaskTextInputFormatter(
                    mask: "#### #### ####",
                    filter: {"#": RegExp(r'[0-9]')},
                  ),
                ],
                decoration: InputDecoration(
                  hintText: "आधार क्रमांक टाका",
                  labelText: "आधार क्रमांक",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      )),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: TextFormField(
                controller: _DOB,
                decoration: InputDecoration(
                  suffixIcon: const Icon(
                    Icons.calendar_month,
                    color: Colors.blue,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: 'जन्मतारीख निवडा',
                  hintText: _selectedDate != null
                      ? "${_selectedDate!.toLocal()}".split(' ')[0]
                      : "तारीख निवडलेली नाही",
                ),
                onTap: () => _selectDate(context),
              ),
            ),
            const SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                value: _selectedGender,
                items: _genders.map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedGender = value;
                  });
                },
                hint: const Text('लिंग निवडा'),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              width: 200,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                onPressed: () {
                  addFamily();
                  // _nametext.clear();
                  // _phone.clear();
                  // adhar_controller.clear();
                  // _DOB.clear();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FamList(token: widget.token),
                    ),
                  );
                },
                child: const Text(
                  "नोंदणी करा",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
