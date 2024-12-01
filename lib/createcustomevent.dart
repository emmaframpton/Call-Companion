import 'package:flutter/material.dart';

class CreateCustomEvent extends StatefulWidget {
  @override
  _CreateCustomEventState createState() => _CreateCustomEventState();
}

class _CreateCustomEventState extends State<CreateCustomEvent> {
  final TextEditingController _eventNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Custom Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: 'Enter event name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String customEventName = _eventNameController.text.trim();
                if (customEventName.isNotEmpty) {
                  Navigator.pop(context, customEventName); // Return the custom event name
                }
              },
              child: Text('Create Event'),
              style: ElevatedButton.styleFrom(
                fixedSize: Size(250, 50),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
