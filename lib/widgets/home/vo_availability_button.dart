import 'package:flutter/material.dart';
import "package:cloud_firestore/cloud_firestore.dart";
import 'package:provider/provider.dart';

import '../../providers/user_model.dart';

class AvailabilityButton extends StatefulWidget {
  const AvailabilityButton({Key? key}) : super(key: key);

  @override
  _AvailabilityButtonState createState() => _AvailabilityButtonState();
}

class _AvailabilityButtonState extends State<AvailabilityButton> {
  @override
  void initState() {
    super.initState();
  }

  void onNotificationButtonPress(bool isAvailable) {
    //TODO: Can show alert dialog for confirmation
    //* https://medium.com/multiverse-software/alert-dialog-and-confirmation-dialog-in-flutter-8d8c160f4095

    //* If Confirmed through dialog, we will perform optimistic update to provider first
    Provider.of<UserModel>(context, listen: false).updateAvailability(isAvailable);

    //TODO: Then we update isAvailable of user on Firestore
  }

  void showAlertDialog(BuildContext context) {
    //TODO: Configure show alert dialog
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserModel>(builder: (context, user, child) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.78,
        height: 40,
        child: ElevatedButton(
          onPressed: () => onNotificationButtonPress(!user.isAvailable),
          child: Text(
            user.isAvailable ? "Enabled Notifications" : "Disabled Notifications",
          ),
          style: ElevatedButton.styleFrom(primary: user.isAvailable ? Colors.green : Theme.of(context).errorColor),
        ),
      );
    });
  }
}
