import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/farmer/services/paddock_search_service.dart';
import 'package:strategic_turtles/services/provider_requests.dart';
import 'package:strategic_turtles/services/services.dart';

class PaddockSearch extends StatefulWidget {
  final RequestModel request;
  final Function onSuccess;

  const PaddockSearch({
    Key key,
    @required this.request,
    this.onSuccess,
  }) : super(key: key);

  @override
  _PaddockSearchState createState() => _PaddockSearchState();
}

class _PaddockSearchState extends State<PaddockSearch> {
  PaddockModel selectedPaddock;
  int selectedIndex;
  String uid;

  @override
  void initState() {
    super.initState();
    final paddockSearchService =
        Provider.of<PaddockSearchService>(context, listen: false);
    final authService = Provider.of<AuthProvider>(context, listen: false);

    uid = authService.getUser.uid;
    paddockSearchService.searchPaddock(uid, "");
  }

  @override
  Widget build(BuildContext context) {
    final paddockSearchService =
        Provider.of<PaddockSearchService>(context, listen: false);
    final requestsService =
        Provider.of<RequestsProvider>(context, listen: false);

    return AlertDialog(
      title: Text('Assign a Paddock'),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                onChanged: (val) {
                  paddockSearchService.searchPaddock(uid, val);
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.only(left: 25.0),
                    hintText: 'Search by paddock name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                    )),
              ),
            ),
            SizedBox(height: 10.0),
            Container(
              width: double.minPositive,
              child: ValueListenableBuilder<List<PaddockModel>>(
                  valueListenable: paddockSearchService.paddocks,
                  builder: (context, farmers, _) {
                    return ListView.builder(
                      padding: EdgeInsets.only(left: 10.0, right: 10.0),
                      primary: false,
                      shrinkWrap: true,
                      itemCount: farmers.length,
                      itemBuilder: (context, idx) {
                        return PaddockItem(
                          selected: selectedIndex == idx,
                          data: farmers[idx],
                          onSelected: (PaddockModel data) {
                            setState(() {
                              selectedIndex = idx;
                              selectedPaddock = data;
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
          child: Text('Accept request'),
          onPressed: selectedPaddock != null
              ? () async {
                  final result = await requestsService.acceptRequest(
                    widget.request.id,
                    widget.request.senderId,
                    selectedPaddock.id,
                  );
                  if (result) {
                    widget.onSuccess.call();
                    Navigator.of(context).pop();
                  }
                }
              : null,
        ),
      ],
    );
  }
}

class PaddockItem extends StatelessWidget {
  final Function(PaddockModel) onSelected;
  final bool selected;
  final PaddockModel data;

  const PaddockItem({
    Key key,
    this.onSelected,
    this.selected,
    this.data,
  }) : super(key: key);

  @override
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
          decoration:
              BoxDecoration(color: selected ? Colors.lightGreen : Colors.white),
          child: Center(
            child: Text(
              data.name,
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
