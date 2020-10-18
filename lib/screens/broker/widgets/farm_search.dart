import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/broker/services/farm_search_service.dart';
import 'package:strategic_turtles/services/provider_requests.dart';

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
      title: Text('Select A Farm'),
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
                    prefixIcon: IconButton(
                      color: Colors.black,
                      icon: Icon(Icons.arrow_back),
                      iconSize: 20.0,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    contentPadding: EdgeInsets.only(left: 25.0),
                    hintText: 'Search by name',
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
                          onSelected: (FarmItemState state) {
                            setState(() {
                              selectedIndex = idx;
                              selectedFarm = state.widget.data;
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
      actions: <Widget>[
        TextButton(
          child: Text('Approve'),
          onPressed: () {
            requestsService.createRequest(
                widget.user.uid,
                '${widget.user.firstName} ${widget.user.lastName}',
                selectedFarm.uid,
                selectedFarm.farmName);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class FarmItem extends StatefulWidget {
  final Function(FarmItemState) onSelected;
  final bool selected;

  const FarmItem({
    Key key,
    @required this.data,
    this.onSelected,
    this.selected,
  }) : super(key: key);

  final UserModel data;

  @override
  FarmItemState createState() => FarmItemState();
}

class FarmItemState extends State<FarmItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected.call(this);
      },
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        elevation: 2.0,
        child: Container(
          decoration: BoxDecoration(
              color: widget.selected ? Colors.lightGreen : Colors.white),
          child: Center(
            child: Text(
              widget.data.farmName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: widget.selected ? Colors.white : Colors.black,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
