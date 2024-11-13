import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventListPage(),
    );
  }
}

class EventListPage extends StatefulWidget {
  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<String> events = []; // Stores event descriptions

  void addEvent(String event) {
    setState(() {
      events.add(event);
    });
  }

  void editEvent(int index, String newEvent) {
    setState(() {
      events[index] = newEvent;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: ListView.builder(
        itemCount: events.length + 1, // extra for +
        itemBuilder: (context, index) {
          if (index == 0) {
            // the + rectangle
            return InkWell(
              onTap: () async {
                final newEvent = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NewEventPage(),
                  ),
                );
                if (newEvent != null) {
                  addEvent(newEvent);
                }
              },
              child: Container(
                margin: EdgeInsets.all(8.0),
                height: 60,
                color: Colors.grey[300],
                child: Center(
                  child: Icon(Icons.add, color: Colors.black, size: 32),
                ),
              ),
            );
          } else {
            // List of events with updated color and border
            final eventIndex = index - 1;
            return InkWell(
              onTap: () async {
                final editedEvent = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditEventPage(
                      event: events[eventIndex],
                    ),
                  ),
                );
                if (editedEvent != null) {
                  editEvent(eventIndex, editedEvent);
                }
              },
              child: Container(
                margin: EdgeInsets.all(8.0),
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFFB57BD5), // Rectangle color
                  border: Border.all(
                    color: Color(0xFF560A7E), // Border color
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Center(
                  child: Text(
                    events[eventIndex],
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

class NewEventPage extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('New Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditEventPage extends StatelessWidget {
  final TextEditingController controller;
  EditEventPage({required String event}) : controller = TextEditingController(text: event);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Edit Event Name'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, controller.text);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
