import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/authentication_widgets/signin_signup_label.dart';
import 'login_form.dart';
import 'signup_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Welcome,',
                    style: kLabelTextStyle,
                  ),
                  const Text(
                    'Sign in to Continue!',
                    style: kLabelTextStyle2,
                  ),
                  const Spacer(),
                  LoginForm(),
                  const Spacer(),
                  SignInAndSignUpLabel(
                    text1: 'I\'m a new user, ',
                    text2: 'Sign Up',
                    onClicked: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignUpPage(),
                      ),
                    ),
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
