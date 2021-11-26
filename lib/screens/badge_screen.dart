import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/badges/badge.dart';
import '../providers/user_model.dart';

//* Displays a list of all of the user's badges
class BadgeScreen extends StatelessWidget {
  static const routeName = '/badge';

  const BadgeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> badges = Provider.of<UserModel>(context, listen: false).badges;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Badges"),
        ),
        body: const Center(
          child: Text("Hello"),
        ),
      ),
    );
  }
}
