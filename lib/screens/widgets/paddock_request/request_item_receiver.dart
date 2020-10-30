import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/farmer/services/paddock_search_service.dart';
import 'package:strategic_turtles/screens/farmer/widgets/paddock_search.dart';
import 'package:strategic_turtles/services/provider_requests.dart';
import 'package:strategic_turtles/utils/constants.dart';

class RequestItemReceiver extends StatefulWidget {
  final RequestModel request;

  const RequestItemReceiver({
    Key key,
    @required this.request,
  }) : super(key: key);

  @override
  _RequestItemReceiverState createState() => _RequestItemReceiverState(request);
}

class _RequestItemReceiverState extends State<RequestItemReceiver> {
  final RequestModel request;
  String status;

  _RequestItemReceiverState(this.request) {
    status = request.status;
  }

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
            SizedBox(height: 8.0),
            status == Constants.Pending
                ? Align(
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        RaisedButton(
                          onPressed: () {
                            _showPaddockSearchDialog();
                          },
                          elevation: 4.0,
                          color: Colors.lightGreen,
                          child: Container(
                            child: Text('Accept'),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        RaisedButton(
                          onPressed: () {
                            _declineRequest();
                          },
                          elevation: 4.0,
                          color: Colors.red[300],
                          child: Container(
                            child: Text('Decline'),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                : SizedBox.shrink(),
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
          child: PaddockSearch(
            request: widget.request,
            onSuccess: () {
              setState(() {
                status = Constants.Accepted;
              });
            },
          ),
        );
      },
    );
  }

  void _declineRequest() async {
    final requestsService =
        Provider.of<RequestsProvider>(context, listen: false);
    final result = await requestsService.declineRequest(request.id);
    if (result) {
      setState(() {
        status = Constants.Rejected;
      });
    }
  }
}
