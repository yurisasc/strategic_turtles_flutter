import 'package:flutter/material.dart';
import 'package:strategic_turtles/models/crops.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/paddock_details_screen.dart';

class PaddockItem extends StatelessWidget {
  final PaddockModel paddock;

  const PaddockItem({
    Key key,
    @required this.paddock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  paddock.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Crop type: ${paddock.cropName}',
                  style: TextStyle(fontSize: 18),
                ),
                SizedBox(height: 16.0),
                RaisedButton(
                  child: Text('View Details'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PaddockDetailsScreen(paddock: paddock)),
                    );
                  },
                )
              ],
            ),
          ),
          Image.asset(
            Crops.getCropImageAsset()[paddock.cropName],
            scale: 2.0,
            fit: BoxFit.fill,
          ),
        ],
      ),
    );
  }
}
