import 'package:find_my_path/widgets/requests/request.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

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
          Semantics(
            label: "The page is receiving live updates for requests",
            child: PulsingIndicator(
              icon: Ionicons.radio_outline,
              message: listenerMessage,
              textColor: const Color(0xff1a3b7b),
              bgColor: const Color(0xff1a3b7b).withOpacity(0),
              onTapFn: () => {},
            ),
          ),
        Expanded(
          child: data.isEmpty
              ? Semantics(
                label: "There are no requests for pathfinding assistance at the moment",
                child: Center(
                    child: Text(
                      "No Pending Requests",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
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
