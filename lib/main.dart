import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walnut_home_page/all_screen.dart';
import 'package:walnut_home_page/provider/customer_healt_experts_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CustomerHealthExpertProvider(),
      child: const AmaraHealthApp(),
    ),
  );
}
