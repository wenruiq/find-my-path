import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:marquee/marquee.dart';

//TODO: Add https://pub.dev/packages/flutter_ringtone_player if got time
class VideoCallPickupScreen extends StatefulWidget {
  static const routeName = '/callpickup';

  final String callerName;
  // final double size;
  // final Color color;

  const VideoCallPickupScreen({
    required this.callerName,
    // this.size = 80,
    // this.color = Colors.tealAccent,
    Key? key,
  }) : super(key: key);

  @override
  State<VideoCallPickupScreen> createState() => _VideoCallPickupScreenState();
}

class _VideoCallPickupScreenState extends State<VideoCallPickupScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      lowerBound: 0.5,
      vsync: this,
    )..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _endCallFunction() {
    Navigator.pop(context);
  }

  void _startCallFunction() {
    //TODO: Change this to navigate back to chat instead
    Navigator.pushNamedAndRemoveUntil(context, '/testcallscreen', ModalRoute.withName('/'));
  }

  //* Function that returns the ripple effect for _buildRipplingCircle
  Widget _buildWaves(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.blue[100]!.withOpacity(1 - _animationController.value),
      ),
    );
  }

  //* Function that returns the rippling circle widget
  Widget _buildRipplingCircle() {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _animationController, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            //* Individual wave ripples, use one line for one ripple
            _buildWaves(225 * _animationController.value),
            _buildWaves(275 * _animationController.value),
            // _buildWaves(275 * _animationController.value),
            _buildWaves(325 * _animationController.value),
            // _buildWaves(325 * _animationController.value),
            Align(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.45,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue[500],
                ),
                child: const Icon(
                  Icons.person,
                  size: 120,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //* Padding controls how close the two action buttons are to each other
        padding: const EdgeInsets.symmetric(horizontal: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          //* Linear Gradient configures background color of this screen
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColorDark,
              Theme.of(context).primaryColor,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        //* Stack contains the rippling circle - at the center, and a column
        child: Stack(
          children: <Widget>[
            _buildRipplingCircle(),

            //* Column axis alignments control the positioning of the call header and action buttons
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  children: [
                    //* Styling for Incoming Call Text
                    const Padding(
                      padding: EdgeInsets.only(
                        bottom: 20,
                      ),
                      child: Text(
                        "Incoming Call",
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),

                    //* Styling for caller name text (uses Marquee for long name handling)
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: AutoSizeText(
                        widget.callerName,
                        maxLines: 1,
                        textAlign: TextAlign.start,
                        minFontSize: 35,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                        overflowReplacement: SizedBox(
                          height: 45,
                          child: Marquee(
                            text: widget.callerName,
                            style: const TextStyle(
                              fontSize: 40,
                              color: Colors.white,
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
                            fadingEdgeEndFraction: 0.1,
                            fadingEdgeStartFraction: 0.1,
                            showFadingOnlyWhenScrolling: true,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                //* This sized box further defines the vertical positioning of incoming call text and action buttons
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.13,
                ),

                //* Row contains two columns - each column being the action button + the label underneath it
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    //* Decline Call Button
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: ElevatedButton(
                            //! onPressed for Decline Call
                            onPressed: _endCallFunction,
                            child: const Icon(
                              Icons.call_end,
                              size: 38,
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const CircleBorder(),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.all(20),
                              ),
                              backgroundColor: MaterialStateProperty.all(Colors.red), // <-- Button color
                              overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(MaterialState.pressed)) return Colors.red[300]; // <-- Splash color
                              }),
                            ),
                          ),
                        ),
                        const Text(
                          "Decline",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),

                    //* Accept Call Button
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: ElevatedButton(
                            //! onPressed for accept call
                            onPressed: _startCallFunction,
                            child: const Icon(
                              Icons.call,
                              size: 38,
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                const CircleBorder(),
                              ),
                              padding: MaterialStateProperty.all(
                                const EdgeInsets.all(20),
                              ),
                              backgroundColor: MaterialStateProperty.all(Colors.green), // <-- Button color
                              overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
                                if (states.contains(MaterialState.pressed)) Colors.green[300]; // <-- Splash color
                              }),
                            ),
                          ),
                        ),
                        const Text(
                          "Accept",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
