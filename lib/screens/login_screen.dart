import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin;

  @override
  void initState() {
    super.initState();
    isLogin = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            child: FittedBox(
              fit: BoxFit.cover,
              child: Image.asset(
                'assets/img/home.jpg',
              ),
            ),
          ),
          Material(
            type: MaterialType.transparency,
            child: Center(
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                decoration: BoxDecoration(
                    color: Color(0xDDFFFFFF),
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                width: 400,
                height: isLogin ? 300 : 481,
                child: Scrollbar(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          isLogin ? LoginForm() : SignUpForm(),
                          isLogin ? _signUpTextButton() : _loginTextButton(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _loginTextButton() {
    return FlatButton(
      onPressed: () {
        setState(() {
          isLogin = true;
        });
      },
      child: Text(
        'Already have an account? Login here',
        style: TextStyle(color: Colors.lightBlue),
      ),
    );
  }

  Widget _signUpTextButton() {
    return FlatButton(
      onPressed: () {
        setState(() {
          isLogin = false;
        });
      },
      child: Text(
        'Don\'t have an account? Sign up here',
        style: TextStyle(color: Colors.lightBlue),
      ),
    );
  }
}
