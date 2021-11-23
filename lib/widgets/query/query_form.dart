import "dart:io";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";

import "../../widgets/query/current_location.dart";
import "package:find_my_path/providers/location_model.dart";
import "package:find_my_path/providers/user_model.dart";

class QueryForm extends StatefulWidget {
  const QueryForm({Key? key, required this.submitFn}) : super(key: key);

  final void Function(
      {required String viID,
      required String viDisplayName,
      required DateTime date,
      required Map<String, double> currentLocationLT,
      required Map<String, double> endLocationLT,
      required String currentLocationText,
      required String endLocationText,
      required String status,
      required BuildContext context,
      XFile? imageFile}) submitFn;

  @override
  _QueryFormState createState() => _QueryFormState();
}

class _QueryFormState extends State<QueryForm> {
  XFile? _imageFile;

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Widget _previewImage() {
    if (_imageFile != null) {
      return Semantics(
        label: 'Photo currently attached',
        child: Column(children: <Widget>[
          //* Photo Preview Dimensions
          Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Image.file(File(_imageFile!.path)),
            decoration: const BoxDecoration(
              color: Colors.black,
              // border: Border.all(color: Theme.of(context).primaryColor, width: 2.0),
            ),
          ),
          const SizedBox(height: 25),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.13,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                  primary: Theme.of(context).primaryColor,
                  onSurface: Theme.of(context).primaryColor,
                  side: BorderSide(color: Theme.of(context).primaryColor)),
              onPressed: () => _openCamera(context),
              child: const Text(
                "Retake Photo",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ]),
      );
    }
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width * 0.9,
      child: OutlinedButton.icon(
        icon: Icon(
          Icons.upload_file,
          size: 60,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () => _openCamera(context),
        label: const Text(
          "Take A Photo",
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }

  //* Create global key to uniquely identify the Form widget and allows validation
  //* Standard practice for Flutter forms
  final _formKey = GlobalKey<FormState>();

  late FocusNode myFocusNode;

  //* Initialize form input vairables
  String _viID = '';
  String _viDisplayName = '';
  late DateTime _date;
  Map<String, double> _currentLocationLT = {'lat': 0, 'long': 0};
  late Map<String, double> _endLocationLT;
  String _currentLocationText = '';
  String _endLocationText = '';
  String _status = '';

  //* Input Controllers
  final TextEditingController _endLocationController = TextEditingController();

  //* Need this to perform validations before submit
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      //* save() fires the onSave() method attached to each TextFormField
      _formKey.currentState!.save();
      var userData = Provider.of<UserModel>(context, listen: false).data;
      _viID = userData['uid'];
      _viDisplayName = userData['displayName'];
      _date = DateTime.now();
      _currentLocationLT = Provider.of<LocationModel>(context, listen: false).currenLocationLT;
      //TODO: Handle endLocationLT;
      _endLocationLT = {'lat': 0, 'long': 0};
      _currentLocationText = Provider.of<LocationModel>(context, listen: false).currentLocationText;
      _status = 'Pending';
      widget.submitFn(
          viID: _viID,
          viDisplayName: _viDisplayName,
          date: _date,
          currentLocationLT: _currentLocationLT,
          endLocationLT: _endLocationLT,
          currentLocationText: _currentLocationText,
          endLocationText: _endLocationText,
          status: _status,
          context: context,
          imageFile: _imageFile);
    }
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
                      autocorrect: true,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(hintText: "Enter your destination"),
                      onSaved: (value) {
                        _endLocationText = value.toString();
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter a destination.";
                        }
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
                    child: _previewImage(),
                  ),
                ],
              ),
            ),
          ),
          //* Submit button
          const SizedBox(height: 25),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.width * 0.13,
            child: ElevatedButton(
              onPressed: () {
                FormState().save();
                _trySubmit();
                // Navigator.pushNamed(context, "/queryloading");
              },
              child: const Text(
                "Send Request",
                style: TextStyle(fontSize: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
