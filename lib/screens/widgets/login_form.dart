import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/services/provider_firebase_auth.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({
    Key key,
  }) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  String _email;
  String _password;
  bool _failedLogin = false;

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Text('Login', style: GoogleFonts.katibeh(fontSize: 32)),
          SizedBox(height: 8.0),
          FormBuilderTextField(
            decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.email),
              labelText: 'Email',
            ),
            validators: [
              FormBuilderValidators.required(),
              FormBuilderValidators.email(),
            ],
            onSaved: (value) {
              _email = value;
            },
          ),
          FormBuilderTextField(
            decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.lock),
              labelText: 'Password',
            ),
            obscureText: true,
            validators: [FormBuilderValidators.required()],
            onSaved: (value) {
              _password = value;
            },
          ),
          SizedBox(height: 8.0),
          _failedLogin
              ? Text(
                  'Invalid email or password',
                  style: TextStyle(color: Colors.red),
                )
              : SizedBox.shrink(),
          Container(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.saveAndValidate()) {
                  _login();
                }
              },
              child: Text(
                'LOGIN',
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }

  void _login() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    var auth = await authProvider.signInWithEmailAndPassword(_email, _password);
    if (!auth) {
      setState(() {
        _failedLogin = true;
      });
    }
  }
}
