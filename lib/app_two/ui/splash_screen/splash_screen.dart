// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:in_app_call_app/app_two/ui/widgets/spacers.dart';
import 'package:in_app_call_app/constants.dart';

class SplashScreen extends StatefulWidget {
  bool accountExists;
  String existingUserID;
  SplashScreen(
      {Key? key, required this.accountExists, required this.existingUserID})
      : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text(
            'In-app call App',
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          )),
      body: Container(
        child: Column(
          children: [
            Vspacer(size.height * 0.75),
            Center(
              child: CircularProgressIndicator(
                color: kPrimaryColor,
              ),
            )
          ],
        ),
      ),
    );
  }
}
