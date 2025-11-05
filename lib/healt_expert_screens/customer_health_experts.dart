import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:walnut_home_page/provider/customer_healt_experts_provider.dart';
import 'package:walnut_home_page/utility/utility_function_class.dart';

class CustomerHealthExperts extends StatefulWidget {
  const CustomerHealthExperts({super.key});

  @override
  State<CustomerHealthExperts> createState() => _CustomerHealthExpertsState();
}

class _CustomerHealthExpertsState extends State<CustomerHealthExperts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('CustomerHealthExperts')),
      body: Consumer<CustomerHealthExpertProvider>(
        builder: (context, value, child) {
          log("the value of length is ${value.expertslist.length}");

          return Column(
            children: [
              ...value.expertslist.map(
                (item) => UtilityFunctionClass.buildExpertCard(item, context,false),
              ),
            ],
          );
        },
      ),
    );
  }
}
