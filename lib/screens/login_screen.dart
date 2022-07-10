import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:homepage_ffw_rennertehausen_cms/froms/loginform.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: LoginForm(),
      ),
    );
  }
}
