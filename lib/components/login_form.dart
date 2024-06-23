import 'package:doctor_app/components/button.dart';
import 'package:doctor_app/providers/dio_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../models/auth_model.dart';
import '../utils/config.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
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
                title: 'Sign In',
                disable: false,
                onPressed: () async {
                  // ///login here
                  final token = await DioProvider()
                      .getToken(_emailController.text, _passController.text);

                  // Navigator.of(context).pushNamed('main');
                  // final user = await DioProvider().getUser(token);
                  // print(user);

                  if (token != null && token.isNotEmpty) {
                    auth.loginSuccess();
                    MyApp.navigatorKey.currentState!.pushNamed('main');
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
