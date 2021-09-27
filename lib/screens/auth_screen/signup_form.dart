import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/widgets/authentication_widgets/auth_button.dart';
import 'package:genesis_packaging_v2/widgets/authentication_widgets/auth_passwordfield.dart';
import 'package:genesis_packaging_v2/widgets/authentication_widgets/auth_textfields.dart';
import 'package:genesis_packaging_v2/widgets/authentication_widgets/google_signin_button.dart';

class SignUpForm extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  SignUpForm({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            AuthenticationTextFields(
              labelText: "Full Name",
              hintText: "Enter Full Name",
            ),
            SizedBox(height: 20.0),
            AuthenticationTextFields(
              labelText: "Email ID",
              hintText: "Enter Email ID",
            ),
            SizedBox(height: 20.0),
            // password textField
            PasswordField(
              labelText: "Password",
              hintText: "Enter Password",
            ),
            SizedBox(height: 20.0),
            AuthenticationButton(
              text: 'Sign Up',
            ),
            SizedBox(height: 10.0),
          ],
        ),
      ),
    );
  }
}
