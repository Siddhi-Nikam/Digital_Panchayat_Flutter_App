import "dart:convert";
import "package:flutter/material.dart";
import "package:http/http.dart" as http;

class Api {
  static const baseUrl = "http://10.0.2.2:3000/api/";

//post method
  static addnewuser(Map newuser) async {
    print(newuser);
    try {
      final res = await http.post(Uri.parse("uri"), body: newuser);
      if (res.statusCode == 200) {
        //
      } else {}
    } catch (e) {
      debugPrint(e.toString());
    }
  }

//get method
  static getuser() async {
    var url = Uri.parse("${baseUrl}get_user");
    try {
      final res = await http.get(url);

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        print(data);
      } else {
        //
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
