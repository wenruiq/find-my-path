import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ionicons/ionicons.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';

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
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).primaryColor,
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
        height: MediaQuery.of(context).size.height * 0.5,
        width: MediaQuery.of(context).size.height * 0.4,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: SvgPicture.asset(
                      imageLoc1,
                      fit: BoxFit.contain,
                      // color: Colors.red,
                      semanticsLabel: "Test Semantics Label",
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    width: MediaQuery.of(context).size.height * 0.36,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5.0, bottom: 15.0),
                            child: Text(
                              "Request Details",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                        //* Start Location Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Icon(
                                Ionicons.location_outline,
                                color: Theme.of(context).primaryColorDark,
                                size: 28,
                              ),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                currentLoc,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                minFontSize: 18,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                overflowReplacement: SizedBox(
                                  height: 22,
                                  child: Marquee(
                                    text: currentLoc,
                                    style: const TextStyle(
                                      fontSize: 18,
                                    ),
                                    scrollAxis: Axis.horizontal,
                                    velocity: 25,
                                    blankSpace: 10,
                                    startAfter: const Duration(
                                      milliseconds: 200,
                                    ),
                                    pauseAfterRound: const Duration(
                                      seconds: 1,
                                      milliseconds: 500,
                                    ),
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    fadingEdgeEndFraction: 0.03,
                                    fadingEdgeStartFraction: 0.03,
                                    showFadingOnlyWhenScrolling: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        //* Divider Row
                        Padding(
                          padding: const EdgeInsets.only(top: 3, bottom: 1),
                          child: Row(
                            children: [
                              Icon(
                                Icons.more_vert,
                                color: Colors.grey[300],
                                size: 28,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(2, 0, 3, 0),
                                  child: Divider(
                                    height: 5,
                                    thickness: 0.2,
                                    color: Colors.grey[400],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        //* End Location Row
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 5, top: 2),
                              child: Icon(
                                Ionicons.navigate_circle_outline,
                                color: Theme.of(context).primaryColorDark,
                                size: 28,
                              ),
                            ),
                            Expanded(
                              child: AutoSizeText(
                                endLoc,
                                maxLines: 1,
                                textAlign: TextAlign.start,
                                minFontSize: 18,
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 18,
                                ),
                                overflowReplacement: SizedBox(
                                  height: 22,
                                  child: Marquee(
                                    text: endLoc,
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 18,
                                    ),
                                    scrollAxis: Axis.horizontal,
                                    velocity: 25,
                                    blankSpace: 10,
                                    startAfter: const Duration(
                                      milliseconds: 200,
                                    ),
                                    pauseAfterRound: const Duration(
                                      seconds: 1,
                                      milliseconds: 500,
                                    ),
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    fadingEdgeEndFraction: 0.03,
                                    fadingEdgeStartFraction: 0.03,
                                    showFadingOnlyWhenScrolling: true,
                                  ),
                                ),
                              ),
                            ),
                          ],
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
