import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

class SingInModel extends ChangeNotifier {
  bool _isVisible = false;

  get isVisible => _isVisible;

  set isVisible(value) {
    _isVisible = value;
    notifyListeners();
  }

  bool _isValid = false;

  get isValid => _isValid;

  set isValid(input) {
    _isValid = EmailValidator.validate(input as String);
    notifyListeners();
  }
}
