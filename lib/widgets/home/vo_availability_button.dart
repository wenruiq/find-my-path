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

  //* Toggling Notifications (Optimistic Update)
  void onNotificationButtonPress(bool isAvailable) async {
    String uid = Provider.of<UserModel>(context, listen: false).uid;

    if (isAvailable) {
      //* Enable notification
      //* Create a callback to pass to showAlertDialog
      void enableNotifications() {
        //* Optimistic update
        Provider.of<UserModel>(context, listen: false).setIsAvailable = isAvailable;
        //* Remove dialog
        Navigator.pop(context);
        //* Update Firestore & show Snackbar
        updateFirestore(context, uid, isAvailable);
      }

      const title = "Enable Notifications";
      const content = "Are you sure you want to enable all notifications?";
      //* This is the main function executed
      showAlertDialog(context, title, content, enableNotifications);
    } else if (!isAvailable) {
      //* Disable notification
      //* Create a callback to pass to showAlertDialog
      void disableNotifications() {
        //* Optimistic update
        Provider.of<UserModel>(context, listen: false).setIsAvailable = isAvailable;
        Navigator.pop(context);
        //* Update Firestore & show Snackbar
        updateFirestore(context, uid, isAvailable);
      }

      const title = "Disable Notifications";
      const content = "Are you sure you want to disable all notifications?";
      //* This is the main function executed
      showAlertDialog(context, title, content, disableNotifications);
    }
  }

  //* Shows Alert Dialog to confirm actions
  void showAlertDialog(BuildContext context, String title, String content, Function callback) {
    //* Set up buttons
    Widget cancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"));
    //* Executes callback if confirm
    Widget confirmButton = TextButton(onPressed: () => callback(), child: const Text("Confirm"));

    //* Set up alert
    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [cancelButton, confirmButton],
      backgroundColor: Colors.white,
    );

    //* Show dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        });
  }

  //* Written as a function to not repeat code in onNotificationButtonPress
  void updateFirestore(BuildContext context, String uid, bool isAvailable) async {
    //* Update Firestore
    try {
      DocumentReference docRef = FirebaseFirestore.instance.collection('users').doc(uid);
      await docRef.update({'isAvailable': isAvailable});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isAvailable ? "Notifications Enabled" : "Notifications Disabled"),
          backgroundColor: isAvailable ? Colors.green : Theme.of(context).errorColor,
        ),
      );
    } on FirebaseException catch (err) {
      if (err.message == null) {
        throw Exception("Firebase Error updating availability of user at onNotificationButtonPress.");
      } else {
        throw Exception(err.message);
      }
    } catch (err) {
      throw Exception("Error updating availability of user at onNotificationButtonPress.");
    }
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
