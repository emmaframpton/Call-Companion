import 'package:flutter/material.dart';
import 'timedate.dart';

void main() {
  runApp(MyApp());
}

// Include location here when implementing!
class Event {
  String eventName;
  String? eventTimeDate;

  Event({this.eventName = "Untitled Event", this.eventTimeDate = "No date selected"});
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Event> events = []; 
  String timeDate = "No date selected";
  
  // Adds new events to the list
  void addEventCallback(Event newEvent) {
    setState(() {
      events.add(newEvent);
    });
  }

  void updateTimeDateCallback(String newTimeDate) {
    setState(() {
      timeDate = newTimeDate;
    });
  }

  String getTimeDate() {
    return timeDate;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventListPage(
        addEventCallback: addEventCallback, 
        updateTimeDateCallback: updateTimeDateCallback,
        events: events, // Pass current list of events
        timeDate: timeDate,
      ),
      initialRoute: '/', // Routes used to return to the same instance of a page you directed away from (e.g. NewEvent -> Time/Date -> Same NewEvent Page)
      routes: {
        '/newEventPage': (context) => NewEventPage(addEventCallback: addEventCallback, updateTimeDateCallback: updateTimeDateCallback, events: events, timeDate: timeDate),
        //'/months': (context) => const Months(title: "Months", updateTimeDateCallback: update,),
      },
    );
  }
}

class EventListPage extends StatefulWidget {
  final Function(Event) addEventCallback; // allows you to add new events to existing list
  final Function(String) updateTimeDateCallback; // allows you to add new events to existing list

  final List<Event>? events; // access to exisiting list
  String timeDate;

  EventListPage({required this.addEventCallback, required this.events, required this.updateTimeDateCallback, required this.timeDate});

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<Event> events = [];
  final ScrollController _scrollController = ScrollController();
  String timeDate = "";

  @override
  void initState() {
    super.initState();
    events = widget.events ?? []; // Initialize events to an empty list if null
    timeDate = widget.timeDate;
  }

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
                        builder: (context) => NewEventPage(
                          addEventCallback: widget.addEventCallback, // allows NewEventPage to add events to the existing list
                          updateTimeDateCallback: widget.updateTimeDateCallback,
                          events: widget.events,
                          timeDate: "No date selected",

                        ),                        
                      ),                     
                    );
                    if (newEvent != null) {
                      widget.addEventCallback(newEvent);  // Call the callback function to add the event
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
                // I haven't implemented anything with editing the event!
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
                    height: 100,
                    decoration: BoxDecoration(
                      color: Color(0xFFB57BD5), // Rectangle color
                      border: Border.all(
                        color: Color(0xFF560A7E), // Border color
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            events[eventIndex].eventName,
                            style: const TextStyle(fontSize: 18, color: Colors.white),
                            overflow: TextOverflow.ellipsis, // Ensure long text doesn't overflow
                          ),
                          const SizedBox(height: 4),
                          Text(
                            events[eventIndex].eventTimeDate ?? 'No time/date set',
                            style: const TextStyle(fontSize: 14, color: Colors.white70), // Lighter color for time/date
                          ),
                        ],
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
  Function(Event) addEventCallback; // Access to updating the event list
  Function(String) updateTimeDateCallback; // Access to updating the event list
  final List<Event>? events;
  String timeDate = "";

  NewEventPage({required this.addEventCallback, required this.events, required this.updateTimeDateCallback, required this.timeDate});
  @override
  _NewEventPageState createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final TextEditingController controller = TextEditingController();
  String? timeDate;
  List<Event>? events;

  // Access to parent variables
  @override
  void initState() {
    super.initState();
    events = widget.events ?? [];
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
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Months(
                            title: "Months",
                            updateTimeDateCallback: widget.updateTimeDateCallback,
                          );
                        },
                      ),
                    );
                    // Allows you to navigate back to same instance of page you left
                    Navigator.pushNamed(
                      context,
                      '/newEventPage',
                    );
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
                widget.addEventCallback(newEvent);

                // Navigate back to the EventListPage
                Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => EventListPage(
          addEventCallback: widget.addEventCallback,
          updateTimeDateCallback: widget.updateTimeDateCallback,
          events: widget.events!, // Pass the updated events list
          timeDate: timeDate!,
        ),
      ),
    );
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
    

                Navigator.popUntil(context, (route) {
              return route.settings.name == '/eventList';
            });
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}