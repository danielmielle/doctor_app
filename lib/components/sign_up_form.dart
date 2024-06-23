import 'package:doctor_app/components/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/auth_model.dart';
import '../providers/dio_provider.dart';
import '../utils/config.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool obsecurePass = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: _nameController,
            keyboardType: TextInputType.text,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Username',
              labelText: 'Username',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.person_outlined),
              prefixIconColor: Colors.black38,
            ),
          ),
          Config.spaceSmall(context),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            cursorColor: Config.primaryColor,
            decoration: const InputDecoration(
              hintText: 'Email Address',
              labelText: 'Email',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.email_outlined),
              prefixIconColor: Colors.black38,
            ),
          ),
          Config.spaceSmall(context),
          TextFormField(
            controller: _passController,
            keyboardType: TextInputType.visiblePassword,
            cursorColor: Config.primaryColor,
            obscureText: obsecurePass,
            decoration: InputDecoration(
              hintText: 'Password',
              labelText: 'Password',
              alignLabelWithHint: true,
              prefixIcon: const Icon(Icons.lock_outlined),
              prefixIconColor: Colors.black38,
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    obsecurePass = !obsecurePass;
                  });
                },
                icon: obsecurePass
                    ? const Icon(Icons.visibility_off_outlined,
                        color: Colors.black38)
                    : const Icon(Icons.visibility_outlined,
                        color: Config.primaryColor),
              ),
            ),
          ),
          Config.spaceSmall(context),
          Consumer<AuthModel>(
            builder: (context, auth, child) {
              return Button(
                width: double.infinity,
                title: 'Sign Up',
                disable: false,
                onPressed: () async {
                  // final userRegistration = await DioProvider().registerUser(
                  //     _nameController.text,
                  //     _emailController.text,
                  //     _passController.text);
                  // if (userRegistration == true) {
                  //   final token = await DioProvider()
                  //       .getToken(_emailController.text, _passController.text);
                  //
                  //   if (token != null && token.isNotEmpty) {
                  //     auth.loginSuccess();
                  //     MyApp.navigatorKey.currentState!.pushNamed('main');
                  //   }
                  // }else{
                  //   print('register unsuccessful');
                  // }
                  try {
                    final registrationSuccess = await DioProvider().registerUser(
                        _nameController.text,
                        _emailController.text,
                        _passController.text
                    );

                    if (registrationSuccess) {
                      final token = await DioProvider().getToken(
                          _emailController.text,
                          _passController.text
                      );

                      if (token != null && token.isNotEmpty) {
                        auth.loginSuccess();
                        MyApp.navigatorKey.currentState!.pushNamed('main');
                      } else {
                        // Handle invalid token
                        print('Invalid or empty token');
                        // Display error message to the user
                      }
                    } else {
                      // Handle registration failure
                      print('Registration failed');
                      // Display specific error message to the user
                    }
                  } catch (e) {
                    // Handle network or other errors
                    print('Error during registration or login: $e');
                    // Display error message to the user
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
