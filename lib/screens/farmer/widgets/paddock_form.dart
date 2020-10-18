import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/crops.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/services/services.dart';

class PaddockForm extends StatefulWidget {
  final UserModel user;
  final GeoCoord coordinate;
  final Function callback;

  const PaddockForm({
    Key key,
    @required this.user,
    @required this.coordinate,
    @required this.callback,
  }) : super(key: key);

  @override
  _PaddockFormState createState() => _PaddockFormState();
}

class _PaddockFormState extends State<PaddockForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey<FormBuilderState>();

  var _crops = List<DropdownMenuItem>();
  String _paddockName;
  String _cropName;
  String _paddockSqm;
  String _numSeed;
  DateTime _harvestDate;

  @override
  void initState() {
    super.initState();
    Crops.getCropImageAsset().keys.forEach((crop) {
      this._crops.add(DropdownMenuItem(
            child: Text(crop),
            value: crop,
          ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Paddock Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          FormBuilderTextField(
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Paddock name',
            ),
            validators: [FormBuilderValidators.required()],
            onSaved: (value) {
              _paddockName = value;
            },
          ),
          FormBuilderDropdown(
            attribute: 'cropName',
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Crop Type',
            ),
            hint: Text('Select Crop Type'),
            validators: [FormBuilderValidators.required()],
            items: _crops,
            allowClear: true,
            onSaved: (value) {
              _cropName = value;
            },
          ),
          FormBuilderTextField(
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Paddock Size (m²)',
            ),
            validators: [
              FormBuilderValidators.required(),
              FormBuilderValidators.numeric(),
            ],
            onSaved: (value) {
              _paddockSqm = value;
            },
          ),
          SizedBox(height: 8.0),
          Container(
            width: double.infinity,
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.saveAndValidate()) {
                  _submit();
                }
              },
              child: Text(
                'ADD PADDOCK',
                style: TextStyle(color: Colors.white),
              ),
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      ),
    );
  }

  void _submit() async {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    final paddockService = Provider.of<PaddockProvider>(context, listen: false);
    await paddockService.createPaddock(
      authService.getUser.uid,
      _paddockName,
      widget.user.farmName,
      widget.coordinate.latitude,
      widget.coordinate.longitude,
      double.parse(_paddockSqm),
      _cropName,
      DateTime.now(),
      0,
    );
    widget.callback.call();
  }
}
