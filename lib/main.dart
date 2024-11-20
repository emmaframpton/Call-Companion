import 'package:flutter/material.dart';
import 'timedate.dart';

void main() {
  runApp(MyApp());
}

class Event {
  String eventName = "";
  String? eventTimeDate;

  Event({this.eventName = "", this.eventTimeDate = ""});

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
  List<Event> events = []; // Stores event descriptions
  final ScrollController _scrollController = ScrollController();

  void addEvent(Event event) {
    setState(() {
      events.add(event);
    });
  }

  void editEvent(int index, Event newEvent) {
    setState(() {
      events[index] = newEvent;
    });
  }

  void scrollUp() {
    _scrollController.animateTo(
      _scrollController.offset - 120, // Scroll up by 100 pixels
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void scrollDown() {
    _scrollController.animateTo(
      _scrollController.offset + 120, // Scroll down by 100 pixels
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: events.length + 1, // Extra item for the "+" button
            itemBuilder: (context, index) {
              if (index == 0) {
                // The "+" button
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
                        events[eventIndex].eventName,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          Positioned(
            right: 16,
            bottom: 100,
            child: Column(
              children: [
                FloatingActionButton(
                  onPressed: scrollUp,
                  child: Icon(Icons.arrow_upward),
                  mini: true,
                ),
                SizedBox(height: 8),
                FloatingActionButton(
                  onPressed: scrollDown,
                  child: Icon(Icons.arrow_downward),
                  mini: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NewEventPage extends StatefulWidget {
  final String? timeDate;
  NewEventPage({this.timeDate});
  @override
  _NewEventPageState createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final TextEditingController controller = TextEditingController();
  String? timeDate;

    @override
  void initState() {
    super.initState();
    timeDate = widget.timeDate;
  }

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Blue color for "Event Name" button
                  ),
                  onPressed: () {
                    // Code to handle adding event name
                  },
                  child: Text('Event Name'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Green color for "Time/Date" button
                  ),
                  onPressed: () async {
                    // Navigate to the Time/Date selection page
                    final selectedTimeDate = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Months(title: "Select Time/Date"),
                      ),
                    );

                    if (selectedTimeDate != null) {
    
                }
                  },
                  child: Text('Time/Date'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for "Location" button
                  ),
                  onPressed: () {
                    // Code to handle adding location
                  },
                  child: Text('Location'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
    Event newEvent = Event(eventName: controller.text, eventTimeDate: timeDate);
    Navigator.pop(context, newEvent);
  },
              child: Text('Add Event'),
            ),
             SizedBox(height: 20),
          RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Selected Time/Date: ', // Bold text
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '$timeDate', // Normal text
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
),

          ],
        ),
      ),
    );
  }
}

class EditEventPage extends StatelessWidget {
  final TextEditingController controller;
  EditEventPage({required Event event}) : controller = TextEditingController(text: event.eventName);
  
  
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Blue color for "Event Name" button
                  ),
                  onPressed: () {
                    // Code to edit the event name
                  },
                  child: Text('Event Name'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green, // Green color for "Time/Date" button
                  ),
                  onPressed: () {
                    // Code to edit the time/date
                  },
                  child: Text('Time/Date'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Red color for "Location" button
                  ),
                  onPressed: () {
                    // Code to edit the location
                  },
                  child: Text('Location'),
                ),
              ],
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