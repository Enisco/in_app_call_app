import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_app_call_app/app_two/ui/create%20account/create_account_screen.dart';
import 'package:in_app_call_app/app_two/ui/home_screen/home_screen_view.dart';

class MyAppTwo extends StatelessWidget {
  final String userIDsaved;
  final bool accountExisting;
  const MyAppTwo(
      {Key? key, required this.accountExisting, required this.userIDsaved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.key,
      title: 'In-App Call App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: accountExisting == true
          ? HomeScreenView(savedUserID: userIDsaved)
          : const CreateAccount(),
    );
  }
}
