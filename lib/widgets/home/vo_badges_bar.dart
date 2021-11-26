import 'package:flutter/material.dart';

import '../badges/badge.dart';
import '../util/slide_route.dart';

//TODO: Change this into badges of some sort instead of star reviews

class BadgesBar extends StatelessWidget {
  final Map<String, dynamic> badges;

  const BadgesBar({
    required this.badges,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, "/badge"),
      // onTap: () => Navigator.push(
      //   context,
      //   SlideRoute(
      //     routeName: '/review',
      //     page: const ReviewScreen(),
      //   ),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          Text(
            "View My Badges",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          Icon(
            Icons.chevron_right,
            size: 24,
            color: Colors.black87,
          ),
        ],
      ),
    );
  }
}
