import 'package:flutter/material.dart';
import 'package:genesis_packaging_v2/provider/email_sign_in_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/authentication_widgets/signin_signup_label.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'signup_form.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);
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
                    'Create Account,',
                    style: kLabelTextStyle,
                  ),
                  const Text(
                    'Sign up to get started!',
                    style: kLabelTextStyle2,
                  ),
                  const Spacer(),
                  const SignUpForm(),
                  const Spacer(),
                  SignInAndSignUpLabel(
                      text1: 'I\'m already a member, ',
                      text2: 'Sign In',
                      onClicked: () {
                        final provider = Provider.of<EmailSignInProvider>(
                            context,
                            listen: false);
                        provider.isLogin = !provider.isLogin;
                        Navigator.of(context).pop();
                      }),
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
