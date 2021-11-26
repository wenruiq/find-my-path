import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class Badge extends StatelessWidget {
  final String type;
  final bool available;

  const Badge({
    required this.type,
    required this.available,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget _friendlyBadge() {
      String availability = available ? "Selected" : "Unselected";

      return Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green[800] as Color, Colors.lightGreenAccent[700] as Color],
          ),
          // color: Colors.red,
        ),
        child: Icon(
          Ionicons.thumbs_up_outline,
          semanticLabel: "Friendly Badge Currently $availability",
          size: MediaQuery.of(context).size.width * 0.25,
          color: available ? Colors.white : Colors.grey[200],
        ),
      );
    }

    const ColorFilter greyscale = ColorFilter.matrix(<double>[
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0.2126,
      0.7152,
      0.0722,
      0,
      0,
      0,
      0,
      0,
      1,
      0,
    ]);

    Widget _expertBadge() {
      String availability = available ? "Selected" : "Unselected";

      return Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepOrange[700] as Color, Colors.amber[300] as Color],
          ),
          // color: Colors.red,
        ),
        child: Icon(
          Icons.local_police_outlined,
          semanticLabel: "Expert Navigator Badge Currently $availability",
          size: MediaQuery.of(context).size.width * 0.25,
          color: available ? Colors.white : Colors.grey[200],
        ),
      );
    }

    Widget _listenerBadge() {
      String availability = available ? "Selected" : "Unselected";

      return Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple[700] as Color, Colors.purpleAccent[400] as Color],
          ),
          // color: Colors.red,
        ),
        child: Icon(
          Icons.hearing_outlined,
          semanticLabel: "Good Listener Badge Currently $availability",
          size: MediaQuery.of(context).size.width * 0.25,
          color: available ? Colors.white : Colors.grey[200],
        ),
      );
    }

    Widget _personalityBadge() {
      String availability = available ? "Selected" : "Unselected";

      return Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[700] as Color, Colors.cyan[700] as Color],
          ),
          // color: Colors.red,
        ),
        child: Icon(
          Icons.sentiment_very_satisfied_outlined,
          semanticLabel: "Great Personality Badge Currently $availability",
          size: MediaQuery.of(context).size.width * 0.25,
          color: available ? Colors.white : Colors.grey[200],
        ),
      );
    }

    Map<String, Widget> badgeDetails = {
      "friendly": _friendlyBadge(),
      "expert": _expertBadge(),
      "listener": _listenerBadge(),
      "personality": _personalityBadge(),
    };

    return ClipOval(
      child: available ? badgeDetails[type] : ColorFiltered(colorFilter: greyscale, child: badgeDetails[type]),
    );
  }
}
