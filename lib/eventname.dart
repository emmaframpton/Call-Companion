import 'package:flutter/material.dart';
import 'main.dart';

class EventName extends StatefulWidget {
  final Function(String) updateEventNameCallback;

  const EventName({super.key, required this.updateEventNameCallback});

  @override
  EventNameState createState() => EventNameState();
}

class EventNameState extends State<EventName> {
  final TextEditingController controller = TextEditingController();
  String? location;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Event Name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () async {
                widget.updateEventNameCallback(controller.text);

                Navigator.popUntil(context, (route) {
                  return route.settings.name == '/newEventPage';
                });
              },
              child: Text('Set Event Name'),
            ),
          ],
        ),
      ),
    );
  }
}
