import 'package:bigpay_app003/app/app_config.dart';
import 'package:bigpay_app003/app/big_pay_app.dart';
import 'package:flutter/material.dart';

void main() async {
  // Initialise app config singleton
  AppConfig();
  await AppConfig.instance!.initialiseApp();

  runApp(const BigPayApp());
}
