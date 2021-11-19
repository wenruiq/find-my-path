import 'package:flutter/material.dart';

import '../../screens/ratings_screen.dart';
import '../util/slide_route.dart';

//TODO: Change this into badges of some sort instead of star reviews

class Rating extends StatelessWidget {
  final double rating;
  final int reviewCount;

  const Rating({
    required this.rating,
    required this.reviewCount,
    Key? key,
  }) : super(key: key);

  IconData starRatingFiller(double starIndex) {
    if (starIndex <= rating) {
      return Icons.star_rate;
    } else if (rating >= (starIndex - 0.5) && rating < starIndex) {
      return Icons.star_half;
    } else {
      return Icons.star_rate_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => Navigator.pushNamed(context, "/rating"),
      onTap: () => Navigator.push(
        context,
        SlideRoute(
          routeName: '/ratings',
          page: const RatingScreen(),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 2.5, right: 5),
            child: Text(
              rating.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          Icon(
            starRatingFiller(1),
            size: 18,
            color: Colors.amber,
          ),
          Icon(
            starRatingFiller(2),
            size: 18,
            color: Colors.amber,
          ),
          Icon(
            starRatingFiller(3),
            size: 18,
            color: Colors.amber,
          ),
          Icon(
            starRatingFiller(4),
            size: 18,
            color: Colors.amber,
          ),
          Icon(
            starRatingFiller(5),
            size: 18,
            color: Colors.amber,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, left: 4),
            child: Text(
              '(${reviewCount})',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
          ),
          const Icon(
            Icons.chevron_right,
            size: 24,
            color: Colors.black,
          ),
        ],
      ),
    );
  }
}
