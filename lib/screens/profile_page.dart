import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/services/provider_firebase_auth.dart';
import 'package:strategic_turtles/utils/constants.dart';

class ProfilePage extends StatefulWidget {
  final userId;
  final String role;

  const ProfilePage({
    Key key,
    this.userId,
    this.role,
  }) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _isEditing;
  String firstName;
  String lastName;
  String phoneNumber;
  String address;

  @override
  void initState() {
    super.initState();
    _isEditing = false;
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    final isCurrentUser = authService.getUser.uid == widget.userId;
    final Future<UserModel> userFuture = isCurrentUser
        ? authService.firestoreUser(authService.getUser)
        : authService.getUserById(widget.userId);

    return FutureBuilder<UserModel>(
      future: userFuture,
      builder: (context, snapshot) {
        final user = snapshot.data;
        if (user != null) {
          return Scaffold(
            backgroundColor: const Color(0xFF585858),
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              backgroundColor: Theme.of(context).accentColor,
              title: Text(
                widget.role == Constants.Farmer
                    ? user.farmName
                    : 'Broker Details',
                style: TextStyle(color: Colors.white),
              ),
            ),
            body: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: 64.0,
              ),
              margin: const EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: 64.0,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      icon: !_isEditing ? Icon(Icons.edit) : Icon(Icons.check),
                      color: Colors.lightGreen,
                      onPressed: () {
                        if (_isEditing) {
                          _submitForm();
                        } else {
                          setState(() {
                            _isEditing = true;
                          });
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        radius: 160.0,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: user.photoUrl != ""
                              ? CachedNetworkImage(
                                  imageUrl: user.photoUrl, fit: BoxFit.contain)
                              : Image.asset('assets/img/user_default.png',
                                  fit: BoxFit.contain),
                        ),
                      ),
                      SizedBox(width: 32.0),
                      Expanded(
                        child: FormBuilder(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.role == Constants.Farmer
                                    ? user.farmName
                                    : 'Broker Profile',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 32.0),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: FormBuilderTextField(
                                      readOnly: !_isEditing,
                                      initialValue: user.firstName,
                                      decoration: const InputDecoration(
                                          filled: true,
                                          labelText: 'First Name',
                                          labelStyle:
                                              TextStyle(color: Colors.green)),
                                      onSaved: (value) {
                                        firstName = value;
                                      },
                                    ),
                                  ),
                                  SizedBox(width: 16),
                                  Flexible(
                                    fit: FlexFit.loose,
                                    child: FormBuilderTextField(
                                      readOnly: !_isEditing,
                                      initialValue: user.lastName,
                                      decoration: const InputDecoration(
                                          filled: true,
                                          labelText: 'Last Name',
                                          labelStyle:
                                              TextStyle(color: Colors.green)),
                                      onSaved: (value) {
                                        lastName = value;
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              FormBuilderTextField(
                                readOnly: true,
                                initialValue: user.email,
                                decoration: const InputDecoration(
                                    filled: true,
                                    labelText: 'Email',
                                    labelStyle: TextStyle(color: Colors.green)),
                              ),
                              SizedBox(height: 16.0),
                              FormBuilderTextField(
                                validators: [FormBuilderValidators.numeric()],
                                readOnly: !_isEditing,
                                initialValue: user.phoneNumber == ''
                                    ? 'Not set'
                                    : user.phoneNumber,
                                decoration: const InputDecoration(
                                    filled: true,
                                    labelText: 'Phone Number',
                                    labelStyle: TextStyle(color: Colors.green)),
                                onSaved: (value) {
                                  phoneNumber = value;
                                },
                              ),
                              SizedBox(height: 16.0),
                              FormBuilderTextField(
                                readOnly: !_isEditing,
                                validators: [FormBuilderValidators.min(15)],
                                initialValue: user.address == ''
                                    ? 'Not set'
                                    : user.address,
                                decoration: const InputDecoration(
                                    filled: true,
                                    labelText: 'Address',
                                    labelStyle: TextStyle(color: Colors.green)),
                                onSaved: (value) {
                                  address = value;
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void _submitForm() {
    if (_formKey.currentState.saveAndValidate()) {
      final authService = Provider.of<AuthProvider>(context, listen: false);
      authService.editProfile(
        widget.userId,
        firstName,
        lastName,
        phoneNumber,
        address,
      );

      setState(() {
        _isEditing = false;
      });
    }
  }
}
