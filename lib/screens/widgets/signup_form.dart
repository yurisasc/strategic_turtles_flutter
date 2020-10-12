import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/services/provider_firebase_auth.dart';
import 'package:strategic_turtles/utils/constants.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({
    Key key,
  }) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  var _roles = List<DropdownMenuItem>();
  String _firstName;
  String _lastName;
  String _email;
  String _password;
  String _selectedRole;

  @override
  void initState() {
    super.initState();
    Constants.roles.forEach((role) {
      this._roles.add(DropdownMenuItem(
            child: Text(role),
            value: role,
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Text('Sign Up', style: GoogleFonts.katibeh(fontSize: 32)),
          SizedBox(height: 8.0),
          FormBuilderTextField(
            decoration: const InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.person),
              labelText: 'First name',
            ),
            validators: [FormBuilderValidators.required()],
            onSaved: (value) {
              _firstName = value;
            },
          ),
          FormBuilderTextField(
            decoration: const InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.person),
              labelText: 'Last name',
            ),
            validators: [FormBuilderValidators.required()],
            onSaved: (value) {
              _lastName = value;
            },
          ),
          FormBuilderTextField(
            decoration: const InputDecoration(
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
          FormBuilderDropdown(
            attribute: 'role',
            decoration: const InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.vpn_key),
              labelText: 'Role',
            ),
            hint: Text('Select Role'),
            validators: [FormBuilderValidators.required()],
            items: _roles,
            allowClear: true,
            onSaved: (value) {
              _selectedRole = value;
            },
          ),
          FormBuilderTextField(
            decoration: InputDecoration(
              filled: true,
              prefixIcon: Icon(Icons.lock),
              labelText: 'Password',
            ),
            obscureText: true,
            validators: [
              FormBuilderValidators.required(),
              FormBuilderValidators.minLength(8),
            ],
            onSaved: (value) {
              _password = value;
            },
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                if(_formKey.currentState.saveAndValidate()) {
                  _signUp();
                }
              },
              child: Text(
                'SIGN UP',
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }

  void _signUp() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.registerWithEmailAndPassword(
      _firstName,
      _lastName,
      _email,
      _selectedRole,
      _password,
    );
  }
}
