import 'package:flutter/material.dart';

//TODO: connect to firebase

class AvailabilityButton extends StatefulWidget {
  final onClick;

  const AvailabilityButton({required this.onClick, Key? key}) : super(key: key);

  @override
  _AvailabilityButtonState createState() => _AvailabilityButtonState();
}

class _AvailabilityButtonState extends State<AvailabilityButton> {
  bool _available = false;

  //TODO: Display spinner while updating whatever status holder (probably firebase)
  void _toggleAvailability() {
    setState(() {
      _available = !_available;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.78,
      height: 40,
      child: ElevatedButton(
        onPressed: _toggleAvailability,
        //* Used to test dialog
        // onPressed: () {
        //   Navigator.of(context).restorablePush(widget.onClick);
        // },
        child: Text(
          //TODO: Discuss wording of this
          _available ? "Enabled Notifications" : "Disabled Notifications",
        ),
        style: ElevatedButton.styleFrom(
            primary: _available ? Colors.green : Theme.of(context).errorColor),
      ),
    );
  }
}
