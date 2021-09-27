import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PasswordField extends StatefulWidget {
  final String labelText;
  final String hintText;
   final TextEditingController? controller;
  const PasswordField({
    Key? key,
    required this.labelText,
    required this.hintText,
    this.controller,
  }) : super(key: key);
  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool? _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return TextField(
      //controller: ,
      obscureText: !_passwordVisible!,
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: const TextStyle(
         // color: kGreyColor,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
          //  color: kGreyColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            //color: kPrimaryColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        suffixIcon: IconButton(
          padding: const EdgeInsets.only(right: 15.0),
          icon: Icon(
            !_passwordVisible!
                ? FontAwesomeIcons.eyeSlash
                : FontAwesomeIcons.eye,
          ),
         // color: kPrimaryColor,
          iconSize: 18.0,
          onPressed: () => setState(
            () {
              _passwordVisible = !_passwordVisible!;
            },
          ),
        ),
      ),
    );
  }
}
