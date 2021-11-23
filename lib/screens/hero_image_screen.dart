import "dart:io";
import "package:flutter/material.dart";
import "package:cached_network_image/cached_network_image.dart";

import "../args/hero_image_screen_args.dart";

//* Handles view image full screen with Hero Animation
//* Reach this page via:
//* Navigator.pushNamed(context, '/heroImage', arguments: HeroImageScreenArgs(tag, filePath, imageURL));
//* Reference: query_form.dart
class HeroImageScreen extends StatefulWidget {
  const HeroImageScreen({Key? key}) : super(key: key);
  static const routeName = '/heroImage';

  @override
  _HeroImageScreenState createState() => _HeroImageScreenState();
}

class _HeroImageScreenState extends State<HeroImageScreen> {
  ImageProvider<Object> _imageProvier(imageURL, filePath) {
    if (imageURL == '') {
      return FileImage(File(filePath));
    }
    return NetworkImage(imageURL);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as HeroImageScreenArgs;
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
          child: Center(
            child: Hero(
              tag: args.tag,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(image: _imageProvier(args.imageURL, args.filePath), fit: BoxFit.fitWidth),
                ),
              ),
            ),
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
