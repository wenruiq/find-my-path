import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/parser.dart';

class RequestDialog extends StatelessWidget {
  final String rid;
  final String viName;
  final String currentLoc;
  final String endLoc;
  final Function updateFirestoreAndProvider;

  const RequestDialog({
    required this.rid,
    required this.viName,
    required this.currentLoc,
    required this.endLoc,
    required this.updateFirestoreAndProvider,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String imageLoc1 = 'assets/images/request_dialog_direction.svg';
    // String imageLoc2 = 'assets/images/request_dialog_travel.svg';

    //* Set up buttons
    Widget cancelButton = Expanded(
      flex: 10,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        child: OutlinedButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            "Cancel",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade700),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.grey.shade400),
          ),
        ),
      ),
    );

    //* Executes callback if confirm
    Widget confirmButton = Expanded(
      flex: 10,
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.05,
        child: ElevatedButton(
          onPressed: () => updateFirestoreAndProvider(rid),
          child: const Text(
            "Accept Request",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),
    );

    return AlertDialog(
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      contentPadding: const EdgeInsets.fromLTRB(12, 24, 12, 0),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          viName + " Needs Your Help!",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 26, color: Theme.of(context).primaryColor),
          maxLines: 2,
        ),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.24,
                    child: SvgPicture.asset(
                      imageLoc1,
                      fit: BoxFit.contain,
                      // color: Colors.red,
                      semanticsLabel: "Test Semantics Label",
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.28,
                    width: MediaQuery.of(context).size.height * 0.3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 5.0),
                          child: Text(
                            "Request Details",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        //* Design 2 - Locations same row as label, align center
                        Text(
                          "From",
                          style: TextStyle(
                            fontSize: 20,
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
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "To",
                          style: TextStyle(
                            fontSize: 20,
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
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  cancelButton,
                  const Spacer(),
                  confirmButton,
                ],
              ),
            )
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
