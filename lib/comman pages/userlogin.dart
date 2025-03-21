import 'dart:convert';
import 'package:digitalpanchayat/configs/config.dart';
import 'package:flutter/material.dart';
//import 'package:digitalpanchayat/config.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../user/outter pages/userdashboard.dart';
import 'userregister.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class userlogin extends StatefulWidget {
  const userlogin({super.key});

  @override
  State<StatefulWidget> createState() {
    return _userloginState();
  }
}

class _userloginState extends State<userlogin> {
  bool _obscureText = true;
  void showhide() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  final _adhartext = TextEditingController();
  final _passtext = TextEditingController();
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void showSuccessToast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text("Logged successfully"),
      duration: Duration(seconds: 2),
    ));
  }

  void showerrortoast() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      backgroundColor: Colors.blue,
      content: Text("Something went wrong check adhar or password"),
    ));
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    if (_adhartext.text.isNotEmpty && _passtext.text.isNotEmpty) {
      var regbody = {"adhar": _adhartext.text, "password": _passtext.text};
      //print(regbody);
      try {
        var response = await http.post(
          Uri.parse('$BaseUrl/login'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(regbody),
        );

        print(response);

        var jsonResponse = jsonDecode(response.body);

        if (jsonResponse['status'] == true) {
          var mytoken = jsonResponse['token'];
          await prefs.setString('token', mytoken);
          showSuccessToast();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => userdashboard(token: mytoken),
            ),
          );
        } else {
          if (mounted) {
            showerrortoast();
          }
        }
      } catch (e) {
        showerrortoast();
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
            child: Padding(
          padding: const EdgeInsets.only(top: 200.0),
          child: Form(
            // key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "वापरकर्ता लॉगिन",
                  style: TextStyle(
                      color: Color.fromARGB(255, 2, 120, 217),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        MaskTextInputFormatter(
                          mask: "#### #### ####",
                          filter: {"#": RegExp(r'[0-9]')},
                        ),
                      ],
                      controller: _adhartext,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "adhar cannot be empty";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "आधार क्रमांक",
                        hintText: "तुमचा आधार क्रमांक टाका",
                        fillColor: Colors.white,
                        suffixIcon: const Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.green,
                            )),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: TextFormField(
                      controller: _passtext,
                      obscureText: _obscureText,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "password cannot be empty";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: "पासवर्ड",
                        hintText: "तुमचा पासवर्ड टाका",
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                            onPressed: () {
                              showhide();
                            },
                            icon: Icon(
                              _obscureText
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.blue,
                            )),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: const BorderSide(
                              color: Colors.green,
                            )),
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Row(
                    children: [
                      const Text("खाते नाही?"),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Userregister()));
                          },
                          child: const Text(
                            "नोंदणी करा",
                            style: TextStyle(color: Colors.blueAccent),
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: SizedBox(
                    height: 50,
                    width: 250,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blueAccent),
                        onPressed: () {
                          loginUser();
                        },
                        child: const Text(
                          "लॉगिन",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        )),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
