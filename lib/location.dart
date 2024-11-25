import 'package:flutter/material.dart';
import 'main.dart';

class Location extends StatefulWidget {
  final Function(String) updateLocationCallback;

  const Location({super.key, required this.updateLocationCallback});

  @override
  LocationState createState() => LocationState();
}

class LocationState extends State<Location> {
  final TextEditingController controller = TextEditingController();
  String? location;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                widget.updateLocationCallback(controller.text);

                Navigator.popUntil(context, (route) {
                  return route.settings.name == '/newEventPage';
                });
              },
              child: Text('Set Location'),
            ),
          ],
        ),
      ),
    );
  }
}
