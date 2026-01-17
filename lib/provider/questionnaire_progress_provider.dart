import 'package:flutter/material.dart';

class QuestionnaireProgressProvider extends ChangeNotifier {
  double completed = 0;
  double total = 0;
  double progress = 0;

  void incrementProgress() {
    completed += 1;
    progress = total != 0 ? (completed / total) : 0;
    notifyListeners();
  }

  void setProgress(double progress) {
    progress = progress;
    notifyListeners();
  }
}
