import 'package:flutter/material.dart';

import '../widgets/assignments/assignments_list.dart';

class AssignmentsScreen extends StatefulWidget {
  static const routeName = '/assignments';

  const AssignmentsScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AssignmentsScreenState createState() => _AssignmentsScreenState();
}

class _AssignmentsScreenState extends State<AssignmentsScreen> {
  late List<String> _demoData;

  @override
  void initState() {
    super.initState();
    _demoData = ['en', 'haha'];
  }

  @override
  Widget build(BuildContext context) {
    String title = "Assignments";

    //* Sets NavBar title based on source of routing
    final arguments = ModalRoute.of(context)?.settings.arguments as Map;
    title = arguments['title'];

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [],
      ),
      body: RefreshIndicator(
        backgroundColor: Colors.white,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () {
          return Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              _demoData.addAll(['wow', 'wew']);
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Refreshed LUL'),
              ),
            );
          });
        },
        child: AssignmentsList(data: _demoData),
      ),
    );
  }
}
