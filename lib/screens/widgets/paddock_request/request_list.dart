import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/widgets/paddock_request/paddock_request.dart';
import 'package:strategic_turtles/services/provider_requests.dart';

import 'request_item_sender.dart';

class RequestList extends StatelessWidget {
  final UserModel user;
  final bool isSender;

  const RequestList({
    Key key,
    this.user,
    this.isSender,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final requestService =
        Provider.of<RequestsProvider>(context, listen: false);
    final stream = isSender
        ? requestService.getSentRequests(user.uid)
        : requestService.getReceivedRequests(user.uid);

    print(user.uid);
    return StreamBuilder<List<RequestModel>>(
      stream: stream,
      builder: (context, stream) {
        if (stream.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (stream.hasError) {
          return Center(child: Text(stream.error.toString()));
        }

        final requests = stream.data;
        if (requests != null && requests.length > 0) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: ListView.builder(
              itemCount: requests.length,
              itemBuilder: (context, idx) {
                return isSender
                    ? RequestItemSender(request: requests[idx])
                    : RequestItemReceiver(request: requests[idx]);
              },
            ),
          );
        } else {
          return Center(
              child: Text(
            'No requests',
            style: TextStyle(color: Colors.white),
          ));
        }
      },
    );
  }
}
