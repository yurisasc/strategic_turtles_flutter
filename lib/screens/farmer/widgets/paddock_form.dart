import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/crops.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/services/services.dart';

/// Form widget that asks the Farmer to input Paddock details
/// in order to create a Paddock.
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
  bool _runPrediction;

  bool _submitted = false;

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
  void deactivate() {
    super.deactivate();
    // Set loading and error status to its initial state when leaving the screen
    final paddockProvider = Provider.of<PaddockProvider>(context);
    paddockProvider.loading = false;
    paddockProvider.errorMessage = null;
  }

  @override
  Widget build(BuildContext context) {
    return FormBuilder(
      key: _formKey,
      child: Column(
        children: [
          Text(
            'Field Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          FormBuilderTextField(
            decoration: const InputDecoration(
              filled: true,
              labelText: 'Field name',
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
              labelText: 'Field Size (Ha)',
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
          FormBuilderCheckbox(
            label: Text('Run prediction on creating field'),
            decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.lightGreen),
            ),
            onSaved: (value) {
              _runPrediction = value;
            },
          ),
          SizedBox(height: 8.0),
          Visibility(
            visible: _submitted && widget.coordinate == null,
            child: Text(
              'Please select your field location on the map',
              style: TextStyle(color: Colors.red),
            ),
          ),
          SizedBox(height: 8.0),
          _predictionErrorMessage(),
          SizedBox(height: 8.0),
          _submitButton(context),
        ],
      ),
    );
  }

  /// A simple submit button widget.
  /// This button will be disabled when the system is predicting yield.
  Widget _submitButton(BuildContext context) {
    final paddockProvider = Provider.of<PaddockProvider>(context);
    return Container(
      width: double.infinity,
      child: RaisedButton(
        onPressed: paddockProvider.loading
            ? null
            : () {
                if (_formKey.currentState.saveAndValidate()) {
                  _submit();
                }
                setState(() {
                  _submitted = true;
                });
              },
        child: paddockProvider.loading
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 16,
                    height: 16,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Creating field ...',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              )
            : Text(
                'ADD FIELD',
                style: TextStyle(color: Colors.white),
              ),
        color: Theme.of(context).accentColor,
      ),
    );
  }

  /// Prediction error message that is only shown when an error occured.
  /// Otherwise it will be hidden
  Widget _predictionErrorMessage() {
    final paddockService = Provider.of<PaddockProvider>(context);
    return paddockService.errorMessage != null
        ? Text(
            'Failed to create farm (${paddockService.errorMessage}), please try again.',
            style: TextStyle(color: Colors.red),
          )
        : SizedBox.shrink();
  }

  /// Submit the form and create a paddock
  void _submit() async {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    final paddockService = Provider.of<PaddockProvider>(context, listen: false);
    if (widget.coordinate != null) {
      final result = await paddockService.createPaddock(
        authService.getUser.uid,
        _paddockName,
        widget.user.farmName,
        widget.coordinate.latitude,
        widget.coordinate.longitude,
        double.parse(_paddockSqm),
        _cropName,
        DateTime.now(),
        DateTime.now().add(Duration(days: 366)),
        0,
        runPrediction: _runPrediction,
      );
      if (result) widget.callback.call();
    }
  }
}
