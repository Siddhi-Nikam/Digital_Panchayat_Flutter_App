import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../outter pages/userdrawer.dart';
import '../../reusable component/button.dart';

class PaymentPage extends StatefulWidget {
  final String token;
  const PaymentPage({super.key, required this.token});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late String uname;
  late String mob;
  late Razorpay _razorpay;
  TextEditingController _amountController = TextEditingController();

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

    // Initialize Razorpay
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print("Payment Successful: ${response.paymentId}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Successful: ${response.paymentId}")),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Failed: ${response.code} | ${response.message}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Payment Failed: ${response.message}")),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print("External Wallet Selected: ${response.walletName}");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("External Wallet Selected: ${response.walletName}")),
    );
  }

  void _openCheckout() {
    double amount = double.tryParse(_amountController.text) ?? 0;

    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Enter a valid amount")),
      );
      return;
    }

    var options = {
      'key': 'rzp_test_XXXXXXXXXXXXXX', // Replace with your Razorpay Key ID
      'amount': (amount * 100).toInt(), // Convert to paise
      'name': 'Siddhi Ashok Nikam',
      'description': 'Payment for E-gram Panchayat Tx payment',
      'prefill': {
        'contact': mob, // Use extracted mobile number from token
        'email': 'user@example.com',
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    _razorpay.clear();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tax Payment", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(
        token: widget.token, // Accessing token here from widget
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
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
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                "कर भरणा",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "कर रक्कम",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            btn(
              text: 'सबमिट करा',
              onPressed: _openCheckout,
              bg_color: Colors.blue,
              textcolor: Colors.white,
              fontSize: 20,
            ),
          ],
        ),
      ),
    );
  }
}




// import 'package:flutter/material.dart';
// import 'package:jwt_decoder/jwt_decoder.dart';
// import '../outter pages/userdrawer.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

// class Tax extends StatefulWidget {
//   final String token;
//   const Tax({super.key, required this.token});

//   @override
//   State<StatefulWidget> createState() {
//     return TaxState();
//   }
// }

// class TaxState extends State<Tax> {
//   late String uname;
//   late String mob;
//   @override
//   void initState() {
//     super.initState();

//     // Decode JWT token and extract the necessary fields
//     try {
//       Map<String, dynamic> jwtdecodetoken = JwtDecoder.decode(widget.token);
//       uname = jwtdecodetoken['uname'];
//       mob = jwtdecodetoken['mob'];
//     } catch (e) {
//       print('Token format is invalid: $e');
//     }

//    }

//   final _taxamount = TextEditingController();

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {}

//   void _handlePaymentError(PaymentFailureResponse response) {}

//   void _handleExternalWallet(ExternalWalletResponse response) {}

//   @override
//   void dispose() {
//     super.dispose();
//     // _razorpay.clear();
//   }

//   var options = {
//     'key': '',
//     'amount': 100,
//     'name': 'Acme Corp.',
//     'description': 'Fine T-Shirt',
//     'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("कर भरणा", style: TextStyle(color: Colors.white)),
//         backgroundColor: Colors.blue,
//         iconTheme: IconThemeData(color: Colors.white),
//       ),
//       drawer: AppDrawer(
//         token: widget.token,
//       ),
//       body: Container(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Text(
//                   "अर्जदाराचे नाव",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 enabled: false,
//                 readOnly: true,
//                 initialValue: uname,
//                 style: TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   labelText: uname,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 10),
//             Align(
//               alignment: Alignment.topLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(left: 8.0),
//                 child: Text(
//                   "अर्जदाराचा मोबाईल नंबर",
//                   style: TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: TextFormField(
//                 readOnly: true,
//                 enabled: false,
//                 initialValue: mob,
//                 style: TextStyle(color: Colors.black),
//                 decoration: InputDecoration(
//                   labelText: mob,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 40.0),
//             TextFormField(
//               keyboardType: TextInputType.number,
//               controller: _taxamount,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter a valid amount';
//                 }
//                 return null;
//               },
//               decoration: InputDecoration(
//                 hintText: "कर रक्कम",
//                 labelText: "कर रक्कम",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10.0),
//                   borderSide: const BorderSide(color: Colors.blue),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             MaterialButton(
//               onPressed: () {
//                 if (_taxamount.text.isNotEmpty) {}
//               },
//               color: Colors.blue,
//               minWidth: 200,
//               child: const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   "भरणा करा",
//                   style: TextStyle(color: Colors.white, fontSize: 20.0),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
