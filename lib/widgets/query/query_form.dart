import "package:flutter/material.dart";

import "../../widgets/query/current_location.dart";

class QueryForm extends StatefulWidget {
  const QueryForm({Key? key, required this.isLoading, required this.submitFn}) : super(key: key);

  final bool isLoading;
  final void Function(
      {required String voID,
      required String viID,
      required String voDisplayName,
      required String viDisplayName,
      required DateTime date,
      required String imageURL,
      required Map<String, double> currenLocationLT,
      required Map<String, double> endLocationLT,
      required String currentLocationText,
      required String endLocationText,
      required String status}) submitFn;

  @override
  _QueryFormState createState() => _QueryFormState();
}

class _QueryFormState extends State<QueryForm> {
  //* Create global key to uniquely identify the Form widget and allows validation
  //* Standard practice for Flutter forms
  final _formKey = GlobalKey<FormState>();

  late FocusNode myFocusNode;

  //* Initialize form input vairables
  String _currentLocationText = "Singapore Management University";
  String _endLocationText = "";

  //* Input Controllers
  final TextEditingController _endLocationController = TextEditingController();

  //* Need this to perform validations before submit
  void _trySubmit() {
    return;
  }

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();
  }

  @override
  void dispose() {
    //* Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //* Current location display
          const CurrentLocation(),
          const SizedBox(height: 25),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //* endLocationText
                  Text(
                    "Where do you want to go?",
                    style: TextStyle(fontSize: 24, color: Theme.of(context).primaryColor),
                  ),
                  TextFormField(
                      key: const ValueKey('endLocation'),
                      controller: _endLocationController,
                      decoration: const InputDecoration(hintText: "Enter your destination"),
                      onSaved: (value) {
                        _endLocationText = value.toString();
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  //* imageURL
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      "Attach A Photo (Optional)",
                      style: TextStyle(fontSize: 24, color: Theme.of(context).primaryColor),
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
                        onPressed: () => Navigator.pushNamed(context, "/homeVO"),
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
          //* Submit button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  FormState().save();
                  _trySubmit();
                  Navigator.pushNamed(context, "/queryloading");
                },
                child: const Text(
                  "Send Request",
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
