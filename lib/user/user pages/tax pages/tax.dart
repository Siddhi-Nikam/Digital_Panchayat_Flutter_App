import 'dart:convert';
import 'package:digitalpanchayat/keys.dart';
//import 'package:digitalpanchayat/user/user%20pages/tax%20pages/paymentSuccessed.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../../../configs/config.dart';
import '../../outter pages/userdrawer.dart';
import '../../../reusable component/button.dart';
import 'package:http/http.dart' as http;

class PaymentPage extends StatefulWidget {
  final String token;
  const PaymentPage({super.key, required this.token});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late String uname;
  late String mob;
  Map<String, dynamic>? intentPaymentData;
  final TextEditingController _amountController = TextEditingController();

  Future payment_confirmation() async {
    try {
      var regbody = {
        "uname": uname,
        "mob": mob.toString(),
        "amount": double.tryParse(_amountController.text.trim()) ?? 0,
        "status": "Successful.!",
        "payment_id": "${intentPaymentData?["id"]}"
      };
      var response = await http.post(
        Uri.parse('$BaseUrl/postPayment'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(regbody),
      );
      print(regbody);
      // Handle the response
      if (response.statusCode == 200) {
        print('Payment added successfully');
      } else {
        print('Failed to add: ${response.body}');
      }
    } catch (err) {
      print("Response error : $err");
    }
  }

  /// Show the payment sheet and confirm the payment
  showPaymentSheet() async {
    try {
      // Show the payment sheet
      await Stripe.instance.presentPaymentSheet().then((val) async {
        if (intentPaymentData?["status"] == "requires_action") {
          await Stripe.instance
              .handleNextAction(intentPaymentData?["client_secret"])
              .then((_) {
            // Confirm the payment manually after action
            confirmPaymentManually();
          });
        } else {
          // Payment successful if no action is required

          // ScaffoldMessenger.of(context).showSnackBar(
          //   const SnackBar(
          //       backgroundColor: Colors.green,
          //       content: Text(
          //         "Payment Successful! ",
          //         style: TextStyle(color: Colors.white),
          //       )),
          // );
          payment_confirmation();
        }
      }).onError((errorMsg, sTrace) {
        if (kDebugMode) {
          print("Error during payment: ${errorMsg.toString()}");
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              backgroundColor: Colors.red,
              content: Text(
                "Payment Failed! ",
                style: TextStyle(color: Colors.white),
              )),
        );
      });
    } on StripeException catch (err) {
      print("StripeException: $err");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Cancelled")),
      );
    }
  }

  /// Create a payment intent with Stripe
  Future<Map<String, dynamic>?> makeIntentForPayment(
      String amountToBeCharged, String currency) async {
    try {
      Map<String, dynamic> paymentInfo = {
        "amount": (double.parse(amountToBeCharged) * 100).toInt().toString(),
        "currency": currency,
        "payment_method_types[]": "card",
        //"payment_method_options[card][request_three_d_secure]": "if_available",
      };

      var responseFromStripeAPI = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: paymentInfo,
        headers: {
          "Authorization": "Bearer $SecretKey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (responseFromStripeAPI.statusCode == 200) {
        return jsonDecode(responseFromStripeAPI.body);
      } else {
        print("Failed to create payment intent: ${responseFromStripeAPI.body}");
        return null;
      }
    } catch (errorMsg) {
      print("Error creating payment intent: $errorMsg");
      return null;
    }
  }

  /// Initialize the payment sheet
  paymentSheetInitialization(String amountToBeCharged, String currency) async {
    try {
      intentPaymentData =
          await makeIntentForPayment(amountToBeCharged, currency);

      if (intentPaymentData == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Payment Initialization Failed ❌")),
        );
        return;
      }

      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: intentPaymentData?["client_secret"],
          allowsDelayedPaymentMethods: true,
          style: ThemeMode.dark,
          merchantDisplayName: "E-Grampanchayat App",
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),
        ),
      );

      // Show the payment sheet
      await showPaymentSheet();
    } catch (err) {
      print("Error initializing payment: $err");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error initializing payment: $err")),
      );
    }
  }

  /// Manually confirm the payment after collecting the payment method
  confirmPaymentManually() async {
    try {
      var confirmResponse = await http.post(
        Uri.parse(
            "https://api.stripe.com/v1/payment_intents/${intentPaymentData?["id"]}/confirm"),
        headers: {
          "Authorization": "Bearer $SecretKey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (confirmResponse.statusCode == 200) {
        var data = jsonDecode(confirmResponse.body);
        payment_confirmation();
        if (data["status"] == "succeeded") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Payment Successful! ✅")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Payment Failed: ${data["status"]} ❌")),
          );
        }
      } else {
        print("Error confirming payment: ${confirmResponse.body}");
      }
    } catch (e) {
      print("Error confirming payment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error confirming payment: $e")),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // Decode JWT token and extract user details
    try {
      Map<String, dynamic> jwtDecodeToken = JwtDecoder.decode(widget.token);
      uname = jwtDecodeToken['uname'];
      mob = jwtDecodeToken['mob'];
    } catch (e) {
      print('Token format is invalid: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tax Payment", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(
        token: widget.token,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /// Name Field
              Align(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
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
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: uname,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              /// Mobile Number Field
              Align(
                alignment: Alignment.topLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
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
                  style: const TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    labelText: mob,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              /// Amount Field
              Align(
                alignment: Alignment.topLeft,
                child: const Text(
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
                decoration: const InputDecoration(
                  labelText: "कर रक्कम",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              /// Submit Button
              btn(
                text: 'सबमिट करा',
                onPressed: () {
                  String input = _amountController.text.trim();

                  if (input.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("कृपया रक्कम प्रविष्ट करा")),
                    );
                    return;
                  }

                  double? amount = double.tryParse(input);
                  if (amount == null || amount <= 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("कृपया वैध रक्कम प्रविष्ट करा")),
                    );
                    return;
                  }

                  // Initialize Payment
                  paymentSheetInitialization(amount.toString(), "INR");
                },
                bg_color: Colors.blue,
                textcolor: Colors.white,
                fontSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
