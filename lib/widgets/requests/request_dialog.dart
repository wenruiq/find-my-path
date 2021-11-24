import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';

class RequestDialog extends StatelessWidget {
  final String rid;
  final String viName;
  final String currentLoc;
  final String endLoc;
  final Function updateFirestore;

  const RequestDialog({
    required this.rid,
    required this.viName,
    required this.currentLoc,
    required this.endLoc,
    required this.updateFirestore,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageLoc1 = 'assets/images/request_dialog_direction.svg';
    // String imageLoc2 = 'assets/images/request_dialog_travel.svg';

    //* Set up buttons
    Widget oldCancelButton = TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel"));

    Widget cancelButton = OutlinedButton(
      onPressed: () => Navigator.pop(context),
      child: const Text("Cancel"),
    );

    //* Executes callback if confirm
    Widget confirmButton = ElevatedButton(
      onPressed: () => updateFirestore(rid),
      child: const Text("Accept"),
    );

    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          // viName + " Needs Your Help!",
          "BALAKRISHNAN Needs Your Help!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, color: Theme.of(context).primaryColor),
          maxLines: 2,
        ),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              child: SvgPicture.asset(
                imageLoc1,
                fit: BoxFit.contain,
                // color: Colors.red,
                semanticsLabel: "Test Semantics Label",
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.22,
              width: MediaQuery.of(context).size.height * 0.3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                    child: Text(
                      "Request Details",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  //* Design 2 - Locations same row as label, align center
                  Text(
                    "From",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    currentLoc,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    "To",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  Text(
                    endLoc,
                    softWrap: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [cancelButton, confirmButton],
      backgroundColor: Colors.white,
    );
  }
}
