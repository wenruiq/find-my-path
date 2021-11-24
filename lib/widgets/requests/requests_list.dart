import 'package:find_my_path/widgets/requests/request.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ionicons/ionicons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../stream_indicator/pulsing_indicator.dart';
import 'request.dart';

//* This widget renders the full scrollable list of requests after clicking an option from RequestsControl
//* Loads PulsingIndicator at the top if option selected is Accept An Request
class RequestsList extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final String type;

  const RequestsList({
    required this.data,
    required this.type,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //* Text styling for PulsingIndicator depending on length of data
    String listenerMessage = data.isEmpty ? "Waiting For Requests" : '${data.length} Pending Requests';
    if (data.length == 1) {
      listenerMessage = "1 Pending Request";
    }

    return Column(
      children: [
        if (type == "request_stream")
          PulsingIndicator(
            icon: Ionicons.radio_outline,
            message: listenerMessage,
          ),
        Expanded(
          child: data.isEmpty
              ? const Center(
                  child: Text("No Pending Requests"),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (ctx, index) {
                    return Request(
                      requestDetails: data[index],
                      type: type,
                    );
                  },
                  // physics: const AlwaysScrollableScrollPhysics(),
                ),
        )
      ],
    );
  }
}
