import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/broker/services/farm_search_service.dart';
import 'package:strategic_turtles/services/provider_requests.dart';

/// Dialog widget to search for a farm.
/// Used by the broker to send a request to the selected farm.
class FarmSearch extends StatefulWidget {
  final UserModel user;

  const FarmSearch({
    Key key,
    this.user,
  }) : super(key: key);

  @override
  _FarmSearchState createState() => _FarmSearchState();
}

class _FarmSearchState extends State<FarmSearch> {
  UserModel selectedFarm;
  int selectedIndex;

  initiateSearch(value) {
    final farmSearchService =
        Provider.of<FarmSearchService>(context, listen: false);
    farmSearchService.searchFarm(widget.user.uid, value);
  }

  @override
  Widget build(BuildContext context) {
    final farmSearchService =
        Provider.of<FarmSearchService>(context, listen: false);
    final requestsService =
        Provider.of<RequestsProvider>(context, listen: false);

    return AlertDialog(
      title: Text('Select a Farm'),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (val) {
                  initiateSearch(val);
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.only(left: 25.0),
                    hintText: 'Search by farm name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4.0))),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.minPositive,
              child: ValueListenableBuilder<List<UserModel>>(
                  valueListenable: farmSearchService.farmers,
                  builder: (context, farmers, _) {
                    return ListView.builder(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: farmers.length,
                      itemBuilder: (context, idx) {
                        return FarmItem(
                          selected: selectedIndex == idx,
                          data: farmers[idx],
                          onSelected: (UserModel data) {
                            setState(() {
                              selectedIndex = idx;
                              selectedFarm = data;
                            });
                          },
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.all(16.0),
      actions: <Widget>[
        TextButton(
          child: Text('Send request'),
          onPressed: selectedFarm != null
              ? () {
                  requestsService.createRequest(
                      widget.user.uid,
                      '${widget.user.firstName} ${widget.user.lastName}',
                      selectedFarm.uid,
                      selectedFarm.farmName);
                  Navigator.of(context).pop();
                }
              : null,
        ),
      ],
    );
  }
}

/// A widget to represent the queried farm
class FarmItem extends StatelessWidget {
  final Function(UserModel) onSelected;
  final bool selected;
  final UserModel data;

  const FarmItem({
    Key key,
    @required this.data,
    this.onSelected,
    this.selected,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected.call(data);
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        child: Container(
          decoration: BoxDecoration(
              color: selected ? Colors.lightGreen : Colors.white),
          child: Center(
            child: Text(
              data.farmName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? Colors.white : Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
