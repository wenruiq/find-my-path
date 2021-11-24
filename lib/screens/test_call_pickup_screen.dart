import 'package:flutter/material.dart';

class TestCallPickupScreen extends StatelessWidget {
  static const routeName = '/testpickupscreen';

  final String callerName;

  const TestCallPickupScreen({required this.callerName, Key? key}) : super(key: key);

  void _endCallFunction() {
    const a = 1;
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Call From " + callerName,
              style: TextStyle(fontSize: 30),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.call_end),
                  color: Colors.red,
                  onPressed: _endCallFunction,
                ),
                IconButton(
                  icon: Icon(Icons.call),
                  color: Colors.green,
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/testcallscreen',
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
