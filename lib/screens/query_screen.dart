import "package:flutter/material.dart";

import "../widgets/util/dismiss_keyboard.dart";
import "../widgets/query/current_location.dart";

//* This screen is the form that VI needs to fill up to get a match
class QueryScreen extends StatefulWidget {
  const QueryScreen({Key? key}) : super(key: key);
  static const routeName = '/query';

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  @override
  Widget build(BuildContext context) {
    return DismissKeyboard(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Enter Details"),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CurrentLocation(),
              const SizedBox(height: 25),
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //* Destination Input
                      Text(
                        "Where do you want to go?",
                        style: TextStyle(
                            fontSize: 24,
                            color: Theme.of(context).primaryColor),
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Enter your destination"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //* Photo Upload Box
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Text(
                          "Attach A Photo (Optional)",
                          style: TextStyle(
                              fontSize: 24,
                              color: Theme.of(context).primaryColor),
                        ),
                      ),
                      Center(
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.35,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: OutlinedButton.icon(
                            icon: Icon(
                              Icons.upload_file,
                              size: 60,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () =>
                                Navigator.pushNamed(context, "/homeVO"),
                            label: const Text(
                              "Take A Photo",
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushNamed(context, "/queryloading"),
                    child: const Text(
                      "Send Request",
                      style: TextStyle(fontSize: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
