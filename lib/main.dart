import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart'; 
import 'timedate.dart';
import 'location.dart';
import 'eventname.dart';

void main() {
  runApp(MyApp());
}

class Event {
  String? eventName;
  String? eventTimeDate;
  String? eventLocation;
  Event({
    this.eventName = "Untitled Event", 
    this.eventTimeDate = "No date selected", 
    this.eventLocation = "No location selected"
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Event> events = []; 
  String eventName = "No name selected";
  String timeDate = "No date selected";
  String location = "No location selected";
  
  void addEventCallback(Event newEvent) {
    setState(() {
      events.add(newEvent);
    });
  }

  void updateEventNameCallback(String newEventName) {
    setState(() {
      eventName = newEventName;
    });
  }

  void updateTimeDateCallback(String newTimeDate) {
    setState(() {
      timeDate = newTimeDate;
    });
  }

  void updateLocationCallback(String newLocation) {
    setState(() {
      location = newLocation;
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
        updateEventNameCallback: updateEventNameCallback,
        updateTimeDateCallback: updateTimeDateCallback,
        updateLocationCallback: updateLocationCallback,
        events: events, // Pass current list of events
        eventName: eventName,
        timeDate: timeDate,
        location: location
      ),
      initialRoute: '/', // Routes used to return to the same instance of a page you directed away from (e.g. NewEvent -> Time/Date -> Same NewEvent Page)
      routes: {
      '/newEventPage': (context) => NewEventPage(
        addEventCallback: addEventCallback, 
        updateEventNameCallback: updateEventNameCallback,
        updateTimeDateCallback: updateTimeDateCallback, 
        updateLocationCallback: updateLocationCallback,
        events: events, 
        eventName: eventName,
        timeDate: timeDate,
        location: location
        ),     
      },
    );
  }
}

class EventListPage extends StatefulWidget {
  final Function(Event) addEventCallback; // allows you to add new events to existing list
  final Function(String) updateEventNameCallback; 
  final Function(String) updateTimeDateCallback;
  final Function(String) updateLocationCallback; 

  final List<Event>? events; // access to exisiting list
  String eventName;
  String timeDate;
  String location;

  EventListPage({
    required this.addEventCallback, 
    required this.updateEventNameCallback,
    required this.updateTimeDateCallback, 
    required this.updateLocationCallback,
    required this.events, 
    required this.timeDate,
    required this.eventName,
    required this.location,
  });

  @override
  _EventListPageState createState() => _EventListPageState();
}

class _EventListPageState extends State<EventListPage> {
  List<Event> events = [];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    events = widget.events ?? []; // Initialize events to an empty list if null
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

void addEventToGoogleCalendar(String title, String description, String location, DateTime startTime, DateTime endTime) {
  final Uri googleCalendarUrl = Uri(
    scheme: 'https',
    host: 'calendar.google.com',
    path: '/calendar/render',
    queryParameters: {
      'action': 'TEMPLATE',
      'text': title,
      'dates': '${_formatDate(startTime)}/${_formatDate(endTime)}',
      'details': description,
      'location': location,
    },
  );
  _launchUrl(googleCalendarUrl);
}

String _formatDate(DateTime dateTime) {
  // Format the date as local time (without converting to UTC)
  return dateTime.toIso8601String().replaceAll('-', '').replaceAll(':', '').split('.').first;
}

 void _launchUrl(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

DateTime parseEventTime(String eventTimeString) {

  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;

  DateFormat format = DateFormat('MMM d, h:mm a');
  DateTime parsedDate = format.parse(eventTimeString);

  int yearToUse = (parsedDate.month < currentMonth) ? currentYear + 1 : currentYear;

  DateTime localParsedDate = DateTime(
    yearToUse,
    parsedDate.month,
    parsedDate.day,
    parsedDate.hour,
    parsedDate.minute,
  );

  return localParsedDate;
}

void showReminderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReminderSelectionDialog();
      },
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
                    widget.updateEventNameCallback("Untitled Event");
                    widget.updateTimeDateCallback("No date selected");
                    widget.updateLocationCallback("No location selected");
                    final newEvent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewEventPage(
                          addEventCallback: widget.addEventCallback, // allows NewEventPage to add events to the existing list
                          updateEventNameCallback: widget.updateEventNameCallback,
                          updateTimeDateCallback: widget.updateTimeDateCallback,
                          updateLocationCallback: widget.updateLocationCallback,
                          events: widget.events,
                          eventName: "Untitled Event",
                          timeDate: "No date selected",
                          location: "No location selected",
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
                      child: Row(
                        children: [
                          // Event details inside an Expanded widget
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  events[eventIndex].eventName ?? "Untitled Event",
                                  style: const TextStyle(fontSize: 18, color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  events[eventIndex].eventTimeDate ?? 'No time/date set',
                                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                                ),
                                Text(
                                  events[eventIndex].eventLocation ?? 'No location set',
                                  style: const TextStyle(fontSize: 14, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          // Reminders Button
                          IconButton(
                            icon: Container(
                            child: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 60,  // Set icon size
                              ),
                            ) ,
                            onPressed: () {
                              showReminderDialog(context);
                            },
                          ),
                          // Calendar Button
                          IconButton(
                            icon: Image.asset(
                              'assets/images/gcalicon.png', 
                              width: 60, 
                              height: 60,
                            ),
                            onPressed: () {
                              DateTime parsedEventTime = parseEventTime(events[eventIndex].eventTimeDate!);

                              addEventToGoogleCalendar(
                                events[eventIndex].eventName ?? "Untitled Event",
                                "Add description here",
                                events[eventIndex].eventLocation ?? "No location",
                                parsedEventTime, 
                                parsedEventTime.add(Duration(hours: 1)),
                              );
                            },
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
  final Function(Event) addEventCallback; // allows you to add new events to existing list
  final Function(String) updateEventNameCallback; 
  final Function(String) updateTimeDateCallback; 
  final Function(String) updateLocationCallback;


  final List<Event>? events; // access to exisiting list
  String eventName;
  String timeDate;
  String location;

  NewEventPage({
    required this.addEventCallback, 
    required this.updateEventNameCallback,
    required this.updateTimeDateCallback, 
    required this.updateLocationCallback,
    required this.events, 
    required this.timeDate,
    required this.eventName,
    required this.location,
    });

  @override
  _NewEventPageState createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final TextEditingController controller = TextEditingController();
  List<Event>? events;
  String? eventName;
  String? timeDate;
  String? location;

  // Access to parent variables
  @override
  void initState() {
    super.initState();
    events = widget.events ?? [];
    eventName = widget.eventName;
    timeDate = widget.timeDate;
    location = widget.location;
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
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return EventName(
                            updateEventNameCallback: widget.updateEventNameCallback,
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
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Location(
                            updateLocationCallback: widget.updateLocationCallback,
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
                  child: Text('Location'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Event newEvent = Event(eventName: widget.eventName, eventTimeDate: widget.timeDate, eventLocation: widget.location);
                widget.addEventCallback(newEvent);

                // Navigate back to the EventListPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventListPage(
                      addEventCallback: widget.addEventCallback,
                      updateEventNameCallback: widget.updateEventNameCallback,
                      updateTimeDateCallback: widget.updateTimeDateCallback,
                      updateLocationCallback: widget.updateLocationCallback,
                      events: widget.events!, // Pass the updated events list
                      eventName: eventName!,
                      timeDate: timeDate!,
                      location: location!,
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
                    text: 'Event Name: ', // Bold text
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '$eventName', // Normal text
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          SizedBox(height: 5),
          RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Time/Date: ', // Bold text
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
          SizedBox(height: 5),
          RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Location: ', // Bold text
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: '$location', // Normal text
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

class ReminderSelectionDialog extends StatefulWidget {
  @override
  _ReminderSelectionDialogState createState() =>
      _ReminderSelectionDialogState();
}

class _ReminderSelectionDialogState extends State<ReminderSelectionDialog> {
  final List<int> reminderOptions = [120, 60, 30, 10]; 
  final Map<int, bool> selectedReminders = {
    120: false,
    60: false,
    30: false,
    10: false,
  };

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select Reminders"),
      content: SingleChildScrollView(
        child: ListBody(
          children: reminderOptions.map((option) {
            return CheckboxListTile(
              title: Text("$option minutes before"),
              value: selectedReminders[option],
              onChanged: (bool? value) {
                setState(() {
                  selectedReminders[option] = value!;
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: Text("Set Reminders"),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); 
          },
          child: Text("Cancel"),
        ),
      ],
    );
  }
}