import "dart:io";
import "package:flutter/material.dart";
import "package:image_picker/image_picker.dart";
import "package:provider/provider.dart";
import 'package:google_place/google_place.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';

import "../../widgets/query/current_location.dart";
import "package:find_my_path/providers/location_model.dart";
import "package:find_my_path/providers/user_model.dart";
import "../../args/hero_image_screen_args.dart";
import "../../data/realtime_location.dart";
import "../../data/realtime_location_dao.dart";

class QueryForm extends StatefulWidget {
  QueryForm({Key? key, required this.submitFn}) : super(key: key);

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

  final RealtimeLocationDAO realtimeLocationDAO = RealtimeLocationDAO();

  @override
  _QueryFormState createState() => _QueryFormState();
}

class _QueryFormState extends State<QueryForm> {
  //* Google places
  GooglePlace? googlePlace;
  List<AutocompletePrediction> predictions = [];

  //* Image Picking
  XFile? _imageFile;

  late StreamSubscription _hisLocationChangeSubscription;

  @override
  void initState() {
    super.initState();

    myFocusNode = FocusNode();

    String apiKey = dotenv.env['GOOGLE_API_KEY'] as String;
    googlePlace = GooglePlace(apiKey);

    // //* Trick to run async await in initState
    Future.delayed(Duration.zero, () async {
      var result = await googlePlace!.autocomplete.get("Singapore");
      if (result != null && result.predictions != null && mounted) {
        setState(() {
          predictions = result.predictions!;
        });
      }
    });

    //TODO: Remove test
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      //* Listen
      DatabaseReference _realtimeLocationRef = FirebaseDatabase.instance.reference().child('realtimeLocation');
      _hisLocationChangeSubscription = _realtimeLocationRef.onValue.listen((event) {
        print("Event heard");

        var snapshot = event.snapshot;
        var value = snapshot.value;
        print("value is @@");
        print(value['lat'].runtimeType);
        double lat = double.parse(value['lat']);
        print(lat.runtimeType);
      });
    });
  }

  @override
  void dispose() {
    //* Clean up the focus node when the Form is disposed.
    myFocusNode.dispose();
    _hisLocationChangeSubscription.cancel();
    super.dispose();
  }

  //TODO: Remove test
  void testFunction() async {
    final location = RealtimeLocation(1.3345, 103.456);
    widget.realtimeLocationDAO.saveRealtimeLocation(location);
    print("DONE");
  }

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

  //* Preview Image & Enable Hero Animation
  Widget _previewImage() {
    if (_imageFile != null) {
      String filePath = _imageFile!.path;
      FileImage fileImage = FileImage(File(filePath));
      String heroTag = 'queryImage';
      //* Hero Image
      return Column(children: <Widget>[
        Semantics(
          label: "The photo currently attached",
          child: GestureDetector(
            child: Hero(
              tag: heroTag,
              child: Container(
                //* Photo Preview Dimensions
                height: MediaQuery.of(context).size.height * 0.35,
                width: MediaQuery.of(context).size.width * 0.8,
                decoration: BoxDecoration(
                  color: Colors.black,
                  image: DecorationImage(image: fileImage, alignment: Alignment.topCenter, fit: BoxFit.fitWidth),
                  border: Border.all(color: Theme.of(context).primaryColor, width: 2.0),
                ),
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/heroImage', arguments: HeroImageScreenArgs(heroTag, filePath, ''));
            },
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
      ]);
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
  DetailsResult? placeDetails;

  //* Input Controllers
  final TextEditingController _endLocationController = TextEditingController();

  //* Need this to perform validations before submit
  void _trySubmit() {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid && placeDetails != null) {
      //* save() fires the onSave() method attached to each TextFormField
      _formKey.currentState!.save();
      var userData = Provider.of<UserModel>(context, listen: false).data;
      _viID = userData['uid'];
      _viDisplayName = userData['displayName'];
      _date = DateTime.now();
      _currentLocationLT = Provider.of<LocationModel>(context, listen: false).currenLocationLT;
      double endLocationLat = placeDetails!.geometry!.location!.lat as double;
      double endLocationLng = placeDetails!.geometry!.location!.lng as double;
      _endLocationLT = {'lat': endLocationLat, 'long': endLocationLng};
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

  int currentTab = 0;
  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      index: currentTab,
      children: [
        SingleChildScrollView(
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
                      Semantics(
                        label: "Tap to start searching for your destination",
                        child: TextFormField(
                          key: const ValueKey('endLocation'),
                          controller: _endLocationController,
                          autocorrect: false,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(hintText: "Your destination"),
                          onSaved: (value) {
                            _endLocationText = value.toString();
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a destination.";
                            }
                          },
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              autoCompleteSearch(value);
                            } else {
                              if (predictions.isNotEmpty && mounted) {
                                setState(() {
                                  predictions = [];
                                });
                              }
                            }
                          },
                          onTap: () => {
                            setState(() {
                              currentTab = currentTab == 1 ? 0 : 1;
                              myFocusNode.requestFocus();
                            })
                          },
                          readOnly: true,
                        ),
                      ),
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
                    // testFunction();
                  },
                  child: const Text(
                    "Send Request",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              ),
            ],
          ),
        ),
        //* Search page
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Semantics(
                label: "Input field to search for locations",
                child: TextField(
                  focusNode: myFocusNode,
                  decoration: InputDecoration(
                    labelText: "Search",
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black54,
                        width: 2.0,
                      ),
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(
                        Icons.clear,
                        semanticLabel: "Tap to go back to form page",
                      ),
                      onPressed: () {
                        setState(() {
                          currentTab = 0;
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      autoCompleteSearch(value);
                    } else {
                      if (predictions.isNotEmpty && mounted) {
                        setState(() {
                          predictions = [];
                        });
                      }
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Semantics(
                  label: "List of search results",
                  child: ListView.builder(
                    itemCount: predictions.length,
                    itemBuilder: (context, index) {
                      return Semantics(
                        label: "Search result number ${index + 1}",
                        child: ListTile(
                          leading: const CircleAvatar(
                            child: Icon(
                              Icons.pin_drop,
                              color: Colors.white,
                            ),
                          ),
                          title: Text(predictions[index].description as String),
                          onTap: () {
                            _endLocationController.text = predictions[index].description as String;
                            getPlaceDetailsById(predictions[index].placeId as String);
                            setState(() {
                              currentTab = 0;
                            });
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void autoCompleteSearch(String value) async {
    var result = await googlePlace!.autocomplete.get(value);
    if (result != null && result.predictions != null && mounted) {
      setState(() {
        predictions = result.predictions!;
      });
    }
  }

  void getPlaceDetailsById(String placeId) async {
    var result = await googlePlace!.details.get(placeId);
    if (result != null && result.result != null && mounted) {
      setState(() {
        placeDetails = result.result;
      });
    }
  }
}
