import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_google_maps/flutter_google_maps.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/crops.dart';
import 'package:strategic_turtles/models/models.dart';
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
  bool _isEditing;

  @override
  void initState() {
    super.initState();
    _isEditing = false;
    Crops.getCropImageAsset().keys.forEach((crop) {
      this._crops.add(DropdownMenuItem(
            child: Text(crop),
            value: crop,
          ));
    });
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
        title: Text('Farm Details'),
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
            Visibility(
              visible: isOwner,
              child: Positioned(
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
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GoogleMap(
                    key: _mapKey,
                    markers: {Marker(position)},
                    initialZoom: 12,
                    initialPosition: position,
                    mapType: MapType.roadmap,
                    interactive: false,
                  ),
                ),
                SizedBox(width: 32),
                Expanded(
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
                              labelText: 'Paddock Name',
                              labelStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 23,
                              )),
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
                          onSaved: (value) {},
                        ),
                        SizedBox(height: 8.0),
                        FormBuilderTextField(
                          readOnly: !_isEditing,
                          initialValue: widget.paddock.sqmSize.toString(),
                          decoration: const InputDecoration(
                              filled: true,
                              labelText: 'Paddock Size (m²)',
                              labelStyle: TextStyle(
                                color: Colors.green,
                                fontSize: 18,
                              )),
                          validators: [
                            FormBuilderValidators.required(),
                            FormBuilderValidators.numeric(),
                          ],
                          onSaved: (value) {},
                        ),
                        SizedBox(height: 8.0),
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _submitForm() {}
}
