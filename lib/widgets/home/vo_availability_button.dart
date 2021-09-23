import 'package:flutter/material.dart';

class AvailabilityButton extends StatefulWidget {
  const AvailabilityButton({Key? key}) : super(key: key);

  @override
  _AvailabilityButtonState createState() => _AvailabilityButtonState();
}

class _AvailabilityButtonState extends State<AvailabilityButton> {
  bool _available = true;

  void _toggleAvailability() {
    setState(() {
      _available = !_available;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 40,
      child: ElevatedButton(
        // style: ButtonStyle(backgroundColor: ),
        onPressed: _toggleAvailability,
        child: Text(
          _available ? "I'm Available!" : "Not Available",
        ),
      ),
    );
  }
}
