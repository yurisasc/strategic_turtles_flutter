import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:strategic_turtles/models/models.dart';
import 'package:strategic_turtles/screens/broker/services/provider_selected_paddock.dart';
import 'package:strategic_turtles/services/provider_requests.dart';

class PaddockInfo extends StatelessWidget {
  final UserModel user;
  final Function callback;

  const PaddockInfo({Key key, this.user, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selectedPaddockService = Provider.of<SelectedPaddock>(context);
    final selectedPaddock = selectedPaddockService.selectedPaddock;
    final requestsService =
        Provider.of<RequestsProvider>(context, listen: false);

    if (selectedPaddock == null) {
      return Center(child: Text('Please select a paddock'));
    } else {
      return Center(
        child: Row(
          children: [
            Text(selectedPaddock.name),
            RaisedButton(
              onPressed: () {
                requestsService.createRequest(
                    user.uid,
                    '${user.firstName} ${user.lastName}',
                    selectedPaddock.ownerId,
                    selectedPaddock.id);
                callback.call();
              },
              child: Text('Send request'),
            ),
          ],
        ),
      );
    }
  }
}
