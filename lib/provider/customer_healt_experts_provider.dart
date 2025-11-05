import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:walnut_home_page/healt_expert_screens/health_expert.dart';

class CustomerHealthExpertProvider extends ChangeNotifier {
  final List<HealthExpert> experts = [];
  UnmodifiableListView<HealthExpert> get expertslist =>
      UnmodifiableListView(experts);
  void add(HealthExpert item) {
    experts.add(item);
    notifyListeners();
  }

  void remove(String id) {
    id = id.trim();
    experts.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}
