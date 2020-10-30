import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/crops.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/widgets/prediction_chart.dart';
import 'package:strategic_turtles/services/services.dart';

class PaddockDetailsScreen extends StatefulWidget {
  final PaddockModel paddock;

  const PaddockDetailsScreen({Key key, this.paddock}) : super(key: key);

  @override
  _PaddockDetailsScreenState createState() => _PaddockDetailsScreenState();
}

class _PaddockDetailsScreenState extends State<PaddockDetailsScreen> {
  var _crops = List<DropdownMenuItem>();
  final _formKey = GlobalKey<FormBuilderState>();
  final _mapKey = GlobalKey<GoogleMapStateBase>();
  final _yieldController = TextEditingController();

  double previousPaddockSize;
  String previousCropName;

  String paddockName;
  String cropName;
  double paddockSize;
  bool _isEditing;
  List<double> estimatedYield;

  @override
  void initState() {
    super.initState();
    // Page initial states
    _isEditing = false;
    previousPaddockSize = widget.paddock.sqmSize;
    previousCropName = widget.paddock.cropName;
    estimatedYield = widget.paddock.estimatedYield;
    _yieldController.text = estimatedYield.isNotEmpty
        ? estimatedYield[0].toString()
        : 0.0.toString();

    // Initialize crop choices
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
    // Set loading and error status to null on leaving the page
    final paddockProvider = Provider.of<PaddockProvider>(context);
    paddockProvider.loading = false;
    paddockProvider.errorMessage = null;
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthProvider>(context, listen: false);
    final isOwner = authService.getUser.uid == widget.paddock.ownerId;
    final position = GeoCoord(
      widget.paddock.latitude,
      widget.paddock.longitude,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF585858),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'Field Details',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButton: Visibility(
        visible: isOwner,
        child: floatingActionButtonEdit(),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _paddockMapPosition(position),
            SizedBox(width: 32),
            _paddockDetailsForm(isOwner),
          ],
        ),
      ),
    );
  }

  /// Floating action button to toggle edit mode.
  Widget floatingActionButtonEdit() {
    final paddockProvider = Provider.of<PaddockProvider>(context);

    return FloatingActionButton.extended(
      icon: paddockProvider.loading
          ? null
          : !_isEditing
              ? Icon(Icons.edit)
              : Icon(Icons.check),
      label: paddockProvider.loading
          ? Text('Predicting ...')
          : !_isEditing
              ? Text('Edit')
              : Text('Save'),
      onPressed: paddockProvider.loading
          ? null
          : () {
              if (_isEditing) {
                _submitForm();
              } else {
                setState(() {
                  _isEditing = true;
                });
              }
            },
    );
  }

  /// The GoogleMap widget to take expanded width.
  Widget _paddockMapPosition(GeoCoord position) {
    return Expanded(
      child: GoogleMap(
        key: _mapKey,
        markers: {Marker(position)},
        initialZoom: 12,
        initialPosition: position,
        mapType: MapType.hybrid,
        interactive: false,
      ),
    );
  }

  /// The paddock details that is editable if the form state is editing.
  Widget _paddockDetailsForm(bool isOwner) {
    final paddockProvider = Provider.of<PaddockProvider>(context);

    return Expanded(
      child: FormBuilder(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FormBuilderTextField(
              readOnly: !_isEditing,
              initialValue: widget.paddock.name,
              validators: [FormBuilderValidators.required()],
              decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Field Name',
                  labelStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 23,
                  )),
              onSaved: (value) {
                paddockName = value;
              },
            ),
            SizedBox(height: 8.0),
            FormBuilderDropdown(
              readOnly: !_isEditing,
              attribute: 'cropName',
              initialValue: widget.paddock.cropName,
              decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Crop Type',
                  labelStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 23,
                  )),
              hint: Text('Select Crop Type'),
              validators: [FormBuilderValidators.required()],
              items: _crops,
              allowClear: true,
              onSaved: (value) {
                cropName = value;
              },
            ),
            SizedBox(height: 8.0),
            FormBuilderTextField(
              readOnly: !_isEditing,
              initialValue: widget.paddock.sqmSize.toString(),
              decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Field Size (Ha)',
                  labelStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 23,
                  )),
              validators: [
                FormBuilderValidators.required(),
                FormBuilderValidators.numeric(),
              ],
              onSaved: (value) {
                paddockSize = double.parse(value);
              },
            ),
            SizedBox(height: 8.0),
            FormBuilderTextField(
              readOnly: true,
              controller: _yieldController,
              decoration: const InputDecoration(
                  filled: true,
                  labelText: 'Yield Estimation (Kg)',
                  labelStyle: TextStyle(
                    color: Colors.green,
                    fontSize: 23,
                  )),
            ),
            SizedBox(height: 8.0),
            estimatedYield.isNotEmpty
                ? Flexible(
                    fit: FlexFit.loose,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Predicted Yield Range',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Container(
                          width: 400,
                          height: 150,
                          child: PredictionChart(
                              predictions: widget.paddock.estimatedYield),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
            _predictionErrorMessage(),
            SizedBox(height: 8.0),
            isOwner
                ? Container(
                    width: double.infinity,
                    child: RaisedButton(
                      padding: const EdgeInsets.all(8.0),
                      onPressed: paddockProvider.loading ? null : _predict,
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
                                  'Predicting ...',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )
                          : Text(
                              'PREDICT',
                              style: TextStyle(color: Colors.white),
                            ),
                      color: Theme.of(context).accentColor,
                    ),
                  )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  /// Use the paddock service to call prediction on the paddock.
  void _predict() async {
    final paddockService = Provider.of<PaddockProvider>(context, listen: false);
    final result = await paddockService.editPaddock(
      widget.paddock,
      true,
    );

    if (result != null) {
      setState(() {
        estimatedYield = result.estimatedYield;
      });
      _yieldController.text = estimatedYield[0].toString();
    }
  }

  /// Prediction error message that is only shown if an error exists.
  Widget _predictionErrorMessage() {
    final paddockService = Provider.of<PaddockProvider>(context);
    return paddockService.errorMessage != null
        ? Text(
            'Prediction error (${paddockService.errorMessage}), please try again.',
            style: TextStyle(color: Colors.red),
          )
        : SizedBox.shrink();
  }

  /// Submit form
  void _submitForm() async {
    if (_formKey.currentState.saveAndValidate()) {
      setState(() {
        _isEditing = false;
      });

      // create a model for editing
      final model = widget.paddock;
      model.name = paddockName;
      model.cropName = cropName;
      model.sqmSize = paddockSize;

      // edit the paddock and check if prediction is needed to be reran
      final paddockService =
          Provider.of<PaddockProvider>(context, listen: false);
      final rerunPrediction = (previousPaddockSize != paddockSize) ||
          (previousCropName != cropName);
      final result = await paddockService.editPaddock(
        model,
        rerunPrediction,
      );

      // update the chart
      if (result != null) {
        setState(() {
          estimatedYield = result.estimatedYield;
          previousPaddockSize = result.sqmSize;
          previousCropName = result.cropName;
        });
        _yieldController.text = estimatedYield[0].toString();
      }
    }
  }
}
