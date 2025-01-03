import 'package:digitalpanchayat/comman%20pages/adminlogin.dart';
import 'package:digitalpanchayat/comman%20pages/userregister.dart';
import 'package:flutter/material.dart';
import 'userlogin.dart';

class buttons extends StatefulWidget {
  const buttons({super.key});

  @override
  State<StatefulWidget> createState() {
    return buttonState();
  }
}

class buttonState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: Center(
                child: Text(
                  "ई-ग्राम पंचायत मध्ये आपले स्वागत",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Userregister()));
                  },
                  child: const Text(
                    "वापरकर्ता नोंदणी",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                height: 50,
                width: 250,
                child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const userlogin()));
                    },
                    child: const Text(
                      "वापरकर्ता लॉगिन",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    )),
              ),
            ),
            SizedBox(
              height: 50,
              width: 250,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Adminlogin()));
                  },
                  child: const Text(
                    "प्रशासक लॉगिन",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
