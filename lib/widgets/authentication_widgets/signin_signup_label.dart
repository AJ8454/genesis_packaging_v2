
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignInAndSignUpLabel extends StatelessWidget {
  final String? text1;
  final String? text2;
  final VoidCallback? onClicked;

  const SignInAndSignUpLabel({
    Key? key,
    required this.text1,
    required this.text2,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: RichText(
        text: TextSpan(
          text: text1,
          style: const TextStyle(
            fontSize: 15.0,
            color: Color(0xFF4E4E5A),
          ),
          children: [
            TextSpan(
              text: text2,
              style: const TextStyle(
                fontSize: 15.0,
                color: Color(0xFFD64F7C),
                fontWeight: FontWeight.bold,
              ),
              recognizer: TapGestureRecognizer()..onTap = onClicked,
            ),
          ],
        ),
      ),
    );
  }
}
