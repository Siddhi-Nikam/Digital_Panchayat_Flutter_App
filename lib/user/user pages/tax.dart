import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
import '../outter pages/userdrawer.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class Tax extends StatefulWidget {
  final String token;
  const Tax({super.key, required this.token});

  @override
  State<StatefulWidget> createState() {
    return TaxState();
  }
}

class TaxState extends State<Tax> {
  //_razorpay = Razorpay();

  final _taxamount = TextEditingController();

  @override
  void initState() {
    super.initState();
    //  _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    //  _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    //  _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {}

  void _handlePaymentError(PaymentFailureResponse response) {}

  void _handleExternalWallet(ExternalWalletResponse response) {}

  @override
  void dispose() {
    super.dispose();
    // _razorpay.clear();
  }

  var options = {
    'key': '',
    'amount': 100,
    'name': 'Acme Corp.',
    'description': 'Fine T-Shirt',
    'prefill': {'contact': '8888888888', 'email': 'test@razorpay.com'}
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay Tax"),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(
        token: widget.token,
      ),
      body: Container(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 40.0),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: _taxamount,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
              decoration: InputDecoration(
                hintText: "कर रक्कम",
                labelText: "कर रक्कम",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(color: Colors.blue),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            MaterialButton(
              onPressed: () {
                if (_taxamount.text.isNotEmpty) {}
              },
              color: Colors.blue,
              minWidth: 200,
              child: const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Pay",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
