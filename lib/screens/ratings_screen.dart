import 'package:find_my_path/widgets/requests/request_icon.dart';
import 'package:flutter/material.dart';
import '../widgets/requests/request_icon.dart';

//TODO: Update this to show badges - refer to tele saved msgs
//! currently used for testing widgets only

class RatingScreen extends StatelessWidget {
  static const routeName = '/rating';

  const RatingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Ratings"),
      ),
      body: const Center(
        child: RequestIcon(name: "Alex"),
      ),
    );
  }
}
