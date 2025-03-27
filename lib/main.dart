import 'package:digitalpanchayat/comman%20pages/buttons.dart';
import 'package:digitalpanchayat/configs/keys.dart';
import 'package:digitalpanchayat/firebase_api.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'user/outter pages/notification.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey = PublishKey;
  await Stripe.instance.applySettings();
  await Firebase.initializeApp();
  await FirebaseApi().initNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const buttons(),
      navigatorKey: navigatorKey,
      routes: {
        'NotificationPage': (context) => NotificationPage(
              data: {},
              token: '',
            ),
      },
    );
  }
}
