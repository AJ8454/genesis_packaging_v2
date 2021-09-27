import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/authentication_widgets/signin_signup_label.dart';
import 'package:flutter/services.dart';
import 'signup_form.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  const Text(
                    'Create Account,',
                    style: kLabelTextStyle,
                  ),
                  const Text(
                    'Sign up to get started!',
                    style: kLabelTextStyle2,
                  ),
                  const Spacer(),
                  SignUpForm(),
                  const Spacer(),
                  SignInAndSignUpLabel(
                    text1: 'I\'m already a member, ',
                    text2: 'Sign In',
                    onClicked: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
