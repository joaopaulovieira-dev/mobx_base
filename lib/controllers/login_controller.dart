import 'package:email_validator/email_validator.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
part 'login_controller.g.dart';

class LoginController = _LoginControllerBase with _$LoginController;

abstract class _LoginControllerBase with Store {
  _LoginControllerBase() {
    autorun((_) {
      debugPrint(isEmailvalid.toString());
      debugPrint(isPasswordValid.toString());
    });
  }

  @observable
  String email = "";

  @action
  void setEmail(String v) => email = v;

  @observable
  String password = "";

  @action
  void setPassword(String v) => password = v;

  @observable
  bool passwordVisible = false;

  @action
  void togglePasswordVisibility() => passwordVisible = !passwordVisible;

  @computed
  bool get isEmailvalid => EmailValidator.validate(email);

  @computed
  bool get isPasswordValid => password.length >= 6;

  @computed
  bool get isFormValid => isEmailvalid && isPasswordValid && !loading;

  @observable
  bool loading = false;

  @action
  Future<void> login() async {
    loading = true;

    await Future.delayed(const Duration(seconds: 2));

    loading = false;
  }
}
