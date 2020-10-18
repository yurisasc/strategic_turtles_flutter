import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/crops.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/models/paddock_model.dart';
import 'package:strategic_turtles/screens/widgets/widgets.dart';
import 'package:strategic_turtles/services/provider_paddock.dart';
import 'package:strategic_turtles/utils/constants.dart';

class PaddockList extends StatelessWidget {
  final UserModel user;

  const PaddockList({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final paddockService = Provider.of<PaddockProvider>(context, listen: false);

    return FutureBuilder<Map<String, List<PaddockModel>>>(
      future: paddockService.getPaddocks(user.uid, user.role),
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
            child: user.role == Constants.Farmer
                ? _farmerPaddockList(paddocks)
                : _brokerPaddockList(paddocks),
          );
        } else {
          return Center(
            child: Text(
              'No paddocks',
              style: TextStyle(color: Colors.white),
            ),
          );
        }
      },
    );
  }

  Widget _farmerPaddockList(Map<String, List<PaddockModel>> paddocks) {
    final items = paddocks.values.expand((i) => i).toList();
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, idx) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: PaddockItem(paddock: items[idx]),
        );
      },
    );
  }

  Widget _brokerPaddockList(Map<String, List<PaddockModel>> paddocks) {
    final entry = paddocks.entries.toList();
    return ListView.builder(
      itemCount: entry.length,
      itemBuilder: (context, idx) {
        final farmName = entry[idx].value.first.farmName;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: GroupedPaddockItem(
            farmId: entry[idx].key,
            farmName: farmName,
            paddocks: entry[idx].value,
          ),
        );
      },
    );
  }
}

class GroupedPaddockItem extends StatelessWidget {
  final String farmId;
  final String farmName;
  final List<PaddockModel> paddocks;

  const GroupedPaddockItem({
    Key key,
    @required this.farmId,
    @required this.farmName,
    @required this.paddocks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              farmName,
              style: TextStyle(fontSize: 28.0, color: Colors.white),
            ),
            FloatingActionButton.extended(
              heroTag: farmId,
              onPressed: () {},
              label: Text(
                'View Profile',
                style:
                    TextStyle(fontWeight: FontWeight.w500, color: Colors.white),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.0),
        Flexible(
          fit: FlexFit.loose,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: paddocks.length,
            itemBuilder: (context, idx) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: PaddockItem(paddock: paddocks[idx]),
              );
            },
          ),
        ),
      ],
    );
  }
}
