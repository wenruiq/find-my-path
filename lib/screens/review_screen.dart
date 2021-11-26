import "package:flutter/material.dart";

//* Page for the VI to give VO badges
class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  static const routeName = "/review";

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  bool _friendlySelected = false;
  bool _expertSelected = false;
  bool _helpfulSelected = false;
  bool _personalitySelected = false;

  Future<bool> showExitPopup() async {
    return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Leave Page?'),
            content: const Text('End this session without leaving a review for your volunteer?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel', style: TextStyle(color: Colors.black)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Confirm', style: TextStyle(color: Colors.red)),
              ),
            ],
            backgroundColor: Colors.white,
          ),
        ) ??
        false;
  }

  Future<bool> _handleExit() async {
    var isExit = await showExitPopup();

    if (isExit) {
      //* Go back to home page
      Navigator.popUntil(context, ModalRoute.withName('/'));
      //* Update firebase with state data
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Rate Your Volunteer"),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(
                Icons.close,
                size: 26,
                semanticLabel: "Button to leave review screen and return to home page",
              ),
              //TODO: Add popup confirmation dialog
              onPressed: () => _handleExit(),
            ),
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //
          ],
        ),
      ),
    );
  }
}
