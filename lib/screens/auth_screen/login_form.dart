import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/widgets/authentication_widgets/auth_button.dart';
import 'package:genesis_packaging_v2/widgets/authentication_widgets/auth_passwordfield.dart';
import 'package:genesis_packaging_v2/widgets/authentication_widgets/auth_textfields.dart';
import 'package:genesis_packaging_v2/widgets/authentication_widgets/google_signin_button.dart';

class LoginForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  LoginForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AuthenticationTextFields(
              labelText: "Email ID",
              hintText: "Enter Email ID",
            ),
            const SizedBox(height: 20.0),
            // password textFiels
            const PasswordField(
              labelText: "Password",
              hintText: "Enter Password",
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(
                    // color: kGreyColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            const AuthenticationButton(
              text: 'Login',
            ),
            const SizedBox(height: 10.0),
            const GoogleSignInButton(),
          ],
        ),
      ),
    );
  }
}
