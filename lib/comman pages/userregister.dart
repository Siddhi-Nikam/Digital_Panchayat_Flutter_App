import 'dart:convert';

import 'package:digitalpanchayat/comman%20pages/userlogin.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:digitalpanchayat/configs/config.dart';

class Userregister extends StatefulWidget {
  const Userregister({super.key});

  @override
  State<StatefulWidget> createState() {
    return _UserregisterState();
  }
}

class _UserregisterState extends State<Userregister> {
  final _formKey = GlobalKey<FormState>();
  final _nametext = TextEditingController();
  final _emailtext = TextEditingController();
  final _phone = TextEditingController();
  final _adhartext = TextEditingController();
  final _passtext = TextEditingController();
  final _date = TextEditingController();

  String? _selectedGender;
  String? _selectedVillage;
  String? _aadhaarValidationMessage;

  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _villages = [
    'Bhalawani',
    'Balwadi',
    'Dhawleshwar',
  ];
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
        _selectedDate = picked; // Update the selected date
      });
    }
  }

  Future<void> checkAadhaar(String adhar) async {
    try {
      final response = await http.get(
        Uri.parse('$BaseUrl/checkAadhar/$adhar'),
      );

      if (response.statusCode == 400) {
        setState(() {
          _aadhaarValidationMessage = 'Aadhaar number already exists';
        });
      } else if (response.statusCode == 200) {
        setState(() {
          _aadhaarValidationMessage = null; // Aadhaar is unique
        });

        userregistered();
      }
    } catch (e) {
      print('Error checking Aadhaar: $e');
    }
  }

  void showSuccessToast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text("Registered successfully"),
    ));
  }

  void showerrortoast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text(
          "Check all fields \nadhar number & mobile number shoud be unique or already exist"),
      duration: Duration(seconds: 4),
    ));
  }

  Future<dynamic> userregistered() async {
    try {
      final isValid = _formKey.currentState!.validate();
      if (isValid && _aadhaarValidationMessage == null) {
        // Changed to proceed if valid
        var regbody = {
          "uname": _nametext.text,
          "mob": _phone.text, // Use .text to get the value
          "adhar": _adhartext.text, // Use .text to get the value
          "DOB": _selectedDate.toString(),
          "gender": _selectedGender.toString(),
          "village": _selectedVillage.toString(),
          "email": _emailtext.text, // Use .text to get the value
          "password": _passtext.text // Use .text to get the value
        };

        var response = await http.post(
          Uri.parse("$BaseUrl/registration"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regbody),
        );
        print(regbody);
        // Handle the response
        if (response.statusCode == 200) {
          // Registration successful
          print('User registered successfully');
          showSuccessToast();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const userlogin()));
          return json.decode(response.body);
        } else {
          // Registration failed
          showerrortoast();
          print('Failed to register: ${response.body}');
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

  // String? validateAadhar(String? value) {
  //   String cleanedValue = value?.replaceAll(RegExp(r'\s+'), '') ?? '';
  //   if (cleanedValue.length == 12 ||
  //       !RegExp(r'^\d{12}$').hasMatch(cleanedValue)) {
  //     return "Enter a valid Aadhar number";
  //   }
  //   return null;
  // }

  String? validatePassword(String? value) {
    if (value == null ||
        value.isEmpty ||
        !RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$')
            .hasMatch(value)) {
      return 'Please enter a valid password';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                const Center(
                  child: Text(
                    "वापरकर्ता नोंदणी",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 2, 127, 230),
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      hintText: "तुमचे पूर्ण नाव एंटर करा",
                      labelText: "पूर्ण नाव",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                      hintText: "तुमचा मोबाईल नंबर टाका",
                      labelText: "मोबाईल नंबर",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      MaskTextInputFormatter(
                        mask: "#### #### ####",
                        filter: {"#": RegExp(r'[0-9]')},
                      ),
                    ],
                    controller: _adhartext,
                    //validator: validateAadhar,
                    decoration: InputDecoration(
                      hintText: "तुमचा आधार क्रमांक टाका",
                      labelText: "आधार क्रमांक",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _emailtext,
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                        return 'Enter a valid email!';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: "तुमचा ईमेल आयडी टाका",
                      labelText: "ईमेल आयडी",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
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
                    hint: const Text('तुमचे लिंग निवडा'),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'गाव निवडा',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    value: _selectedVillage,
                    items: _villages.map((village) {
                      return DropdownMenuItem<String>(
                        value: village,
                        child: Text(village),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedVillage = value;
                      });
                    },
                    hint: const Text('गाव निवडा'),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _passtext,
                    obscureText: _obscureText,
                    validator: validatePassword,
                    decoration: InputDecoration(
                      labelText: "पासवर्ड",
                      hintText: "तुमचा पासवर्ड टाका",
                      suffixIcon: IconButton(
                        onPressed: showhide,
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.blue,
                        ),
                      ),
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextFormField(
                    controller: _date,
                    decoration: InputDecoration(
                      suffixIcon:
                          const Icon(Icons.calendar_month, color: Colors.blue),
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
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      const Text("खाते आहे का?"),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const userlogin(),
                            ),
                          );
                        },
                        child: const Text(
                          "लॉगिन",
                          style: TextStyle(
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 50,
                  width: 200,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: userregistered,
                    //() => checkAadhaar(_adhartext.text),
                    child: const Text("नोंदणी करा",
                        style: TextStyle(color: Colors.white, fontSize: 20)),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
