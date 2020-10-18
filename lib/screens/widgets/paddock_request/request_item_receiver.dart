import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/farmer/services/paddock_search_service.dart';
import 'package:strategic_turtles/screens/farmer/widgets/paddock_search.dart';

class RequestItemReceiver extends StatefulWidget {
  final RequestModel request;

  const RequestItemReceiver({
    Key key,
    @required this.request,
  }) : super(key: key);

  @override
  _RequestItemReceiverState createState() => _RequestItemReceiverState();
}

class _RequestItemReceiverState extends State<RequestItemReceiver> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sent by: ${widget.request.senderName}',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Status: ${widget.request.status}',
              style: TextStyle(fontSize: 18),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                children: [
                  RaisedButton(
                    onPressed: () {
                      _showPaddockSearchDialog();
                    },
                    elevation: 4.0,
                    color: Colors.green,
                    child: Container(
                      child: Text('Accept'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {},
                    elevation: 4.0,
                    color: Colors.red,
                    child: Container(
                      child: Text('Decline'),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPaddockSearchDialog() async {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return ChangeNotifierProvider(
            create: (context) => PaddockSearchService(),
            child: PaddockSearch(request: widget.request));
      },
    );
  }
}
