import "package:flutter/material.dart";

class QueryScreen extends StatefulWidget {
  const QueryScreen({Key? key}) : super(key: key);

  @override
  State<QueryScreen> createState() => _QueryScreenState();
}

class _QueryScreenState extends State<QueryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  child: Icon(Icons.location_pin, size: 35),
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  direction: Axis.vertical,
                  children: <Widget>[
                    const Text(
                      "Current Location:",
                      style: TextStyle(fontSize: 20),
                    ),
                    // Divider(thickness: 5, color: Colors.grey),
                    //TODO: Change this to current location of user
                    Text(
                      "Singapore Management University",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            Form(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //* Destination Input
                    const Text(
                      "Where do you want to go?",
                      style: TextStyle(fontSize: 24),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          hintText: "Enter your destination"),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    //* Photo Upload Box
                    const Padding(
                      padding: EdgeInsets.only(bottom: 20),
                      child: Text(
                        "Attach A Photo (Optional)",
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.upload_file, size: 60),
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
                  onPressed: () => Navigator.pushNamed(context, "/chat"),
                  child: const Text(
                    "Send Request",
                    style: TextStyle(fontSize: 25),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
