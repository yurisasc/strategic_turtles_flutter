import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/crops.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/models/paddock_model.dart';
import 'package:strategic_turtles/services/provider_paddock.dart';

class PaddockList extends StatelessWidget {
  final UserModel user;

  const PaddockList({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddockService = Provider.of<PaddockProvider>(context, listen: false);

    return StreamBuilder<List<PaddockModel>>(
      stream: paddockService.getPaddocks(user.uid, user.role),
      builder: (context, stream) {
        if (stream.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (stream.hasError) {
          return Center(child: Text(stream.error.toString()));
        }

        final paddocks = stream.data;
        if (paddocks != null && paddocks.length > 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: ListView.builder(
              itemCount: paddocks.length,
              itemBuilder: (context, idx) {
                return PaddockItem(paddock: paddocks[idx]);
              },
            ),
          );
        } else {
          return Center(
              child: Text(
            'No paddocks',
            style: TextStyle(color: Colors.white),
          ));
        }
      },
    );
  }
}

class PaddockItem extends StatelessWidget {
  final PaddockModel paddock;

  const PaddockItem({
    Key key,
    @required this.paddock,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
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
                SizedBox(height: 8.0),
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
