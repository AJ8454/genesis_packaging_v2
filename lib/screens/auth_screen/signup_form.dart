import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:genesis_packaging_v2/provider/email_sign_in_provider.dart';
import 'package:genesis_packaging_v2/utility/constant.dart';
import 'package:genesis_packaging_v2/widgets/snack_bar.dart';
import 'package:provider/provider.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  bool? _passwordVisible = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildUsernameField(),
            const SizedBox(height: 15.0),
            buildEmailField(),
            const SizedBox(height: 15.0),
            buildPasswordField(),
            const SizedBox(height: 20.0),
            buildButton(context),
          ],
        ),
      ),
    );
  }

  buildUsernameField() {
    final provider = Provider.of<EmailSignInProvider>(context);
    return TextFormField(
      decoration: textfieldDecoration(
        'Full Name',
        'Enter Full Name',
      ),
      onSaved: (username) => provider.userName = username!,
      validator: (value) {
        if (value!.isEmpty || value.contains(' ')) {
          return 'Please enter your name';
        } else {
          return null;
        }
      },
    );
  }

  buildEmailField() {
    final provider = Provider.of<EmailSignInProvider>(context);
    return TextFormField(
      key: const ValueKey('email'),
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      enableSuggestions: false,
      validator: (value) {
        const pattern = r'(^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$)';
        final regExp = RegExp(pattern);

        if (!regExp.hasMatch(value!)) {
          return 'Enter a valid email';
        } else {
          return null;
        }
      },
      keyboardType: TextInputType.emailAddress,
      decoration: textfieldDecoration(
        'Email Address',
        'Enter Email Address',
      ),
      onSaved: (email) => provider.userEmail = email!,
    );
  }

  buildPasswordField() {
    final provider = Provider.of<EmailSignInProvider>(context);
    return TextFormField(
      key: const ValueKey('password'),
      obscureText: !_passwordVisible!,
      validator: (value) {
        if (value!.isEmpty || value.length < 7) {
          return 'Password must be at least 7 characters long';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        labelText: 'Password',
        hintText: 'Enter Password',
        labelStyle: const TextStyle(
          color: kGreyColor,
        ),
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: kGreyColor,
            width: 2.0,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: kPrimaryColor,
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
          color: kPrimaryColor,
          iconSize: 18.0,
          onPressed: () => setState(
            () => _passwordVisible = !_passwordVisible!,
          ),
        ),
      ),
      onSaved: (password) => provider.userPassword = password!,
    );
  }

  textfieldDecoration(String? labelText, String? hintText) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      labelStyle: const TextStyle(
        color: kGreyColor,
      ),
      border: const OutlineInputBorder(
        borderSide: BorderSide(
          color: kGreyColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(
          color: kPrimaryColor,
          width: 2.0,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    final provider = Provider.of<EmailSignInProvider>(context);

    if (provider.isLoading) {
      return const CircularProgressIndicator();
    } else {
      return buildSignupButton(context);
    }
  }

  Widget buildSignupButton(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
        primary: kPrimaryColor,
        onPrimary: Colors.white,
        shape: const StadiumBorder(),
      ),
      onPressed: () => submit(),
      child: const Text(
        'Sign Up',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Future submit() async {
    final provider = Provider.of<EmailSignInProvider>(context, listen: false);

    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      final isSuccess = await provider.login();
      if (isSuccess!) {
        Navigator.of(context).pop();
      } else {
        const message = 'An error occurred, please check your credentials!';
        SnackBarWidget.showSnackBar(
          context,
          message,
        );
      }
    }
  }
}
