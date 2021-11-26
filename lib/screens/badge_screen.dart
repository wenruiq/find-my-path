import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/badges/badge.dart';
import '../providers/user_model.dart';

//* Displays a list of all of the user's badges
class BadgeScreen extends StatelessWidget {
  final Map<String, String> badgeTitles = const {
    "friendly": "Friendly Individual",
    "expert": "Expert Navigator",
    "listener": "Great Listener",
    "personality": "Amazing Personality",
  };

  static const routeName = '/badge';

  const BadgeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> badges = Provider.of<UserModel>(context, listen: false).badges;
    List<String> types = badges.keys.toList();
    int length = badges.keys.length;
    print("These are badges");
    print(badges.keys.length);

    Map<String, Color> badgeColor = {
      "friendly": Colors.green[800] as Color,
      "expert": Colors.deepOrange[700] as Color,
      "listener": Colors.deepPurple[700] as Color,
      "personality": Colors.blue[700] as Color,
    };

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("My Badges"),
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                      itemCount: length,
                      itemBuilder: (ctx, index) {
                        String currentBadge = types[index];
                        print("This is current badge");
                        int badgeCount = badges[currentBadge];
                        bool availability = badgeCount > 0 ? true : false;
                        Color badgeTitleColor = badgeColor[currentBadge] as Color;

                        String title;
                        if (badgeTitles.containsKey(currentBadge)) {
                          title = badgeTitles[currentBadge] as String;
                        } else {
                          title = "Badge";
                        }

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  title,
                                  style: TextStyle(
                                    fontSize: 35,
                                    color: availability ? badgeTitleColor : Colors.grey[600],
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Badge(
                                  available: availability,
                                  type: currentBadge,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
                                child: Text(
                                  availability ? "Collected $badgeCount of these!" : "None collected yet",
                                  style: const TextStyle(fontSize: 26),
                                ),
                              ),
                              Divider(
                                  indent: MediaQuery.of(context).size.width * 0.3,
                                  endIndent: MediaQuery.of(context).size.width * 0.3),
                            ],
                          ),
                        );
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
