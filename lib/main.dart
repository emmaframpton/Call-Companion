import 'package:flutter/material.dart';
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
  List<Event> filteredEvents = [];
  final TextEditingController searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    events = widget.events ?? [];
    filteredEvents = events; // Initially, show all events
    searchController.addListener(_filterEvents); // Listen to changes in the search input
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _filterEvents() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredEvents = events.where((event) {
        return (event.eventName?.toLowerCase().contains(query) ?? false) ||
               (event.eventTimeDate?.toLowerCase().contains(query) ?? false) ||
               (event.eventLocation?.toLowerCase().contains(query) ?? false);
      }).toList();
    });
  }

  void addEvent(Event event) {
    setState(() {
      events.add(event);
      _filterEvents(); // Re-filter after adding a new event
    });
  }

  void editEvent(int index, Event newEvent) {
    setState(() {
      events[index] = newEvent;
      _filterEvents(); // Re-filter after editing an event
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search events...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: filteredEvents.length + 1, // Include "+" button
            itemBuilder: (context, index) {
              if (index == 0) {
                return _buildAddEventButton(context);
              } else {
                final eventIndex = index - 1;
                return _buildEventCard(context, eventIndex);
              }
            },
          ),
          _buildScrollButtons(),
        ],
      ),
    );
  }

  Widget _buildAddEventButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        widget.updateEventNameCallback("Untitled Event");
        widget.updateTimeDateCallback("No date selected");
        widget.updateLocationCallback("No location selected");
        final newEvent = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewEventPage(
              addEventCallback: widget.addEventCallback,
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
          widget.addEventCallback(newEvent);
        }
      },
      child: Container(
        margin: EdgeInsets.all(8.0),
        height: 60,
        decoration: BoxDecoration(
          color: Color(0xFFB57BD5),
          border: Border.all(
            color: Color(0xFF560A7E),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Icon(Icons.add, color: Colors.white, size: 32),
        ),
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, int eventIndex) {
    return Container(
      margin: EdgeInsets.all(8.0),
      height: 100,
      decoration: BoxDecoration(
        color: Color(0xFFB57BD5),
        border: Border.all(
          color: Color(0xFF560A7E),
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  filteredEvents[eventIndex].eventName ?? "Untitled Event",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  filteredEvents[eventIndex].eventTimeDate ?? 'No time/date set',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
                Text(
                  filteredEvents[eventIndex].eventLocation ?? 'No location set',
                  style: TextStyle(fontSize: 14, color: Colors.white70),
                ),
              ],
            ),
            Spacer(),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.white),
              onPressed: () {
                setState(() {
                  events.removeAt(eventIndex);
                  _filterEvents();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollButtons() {
    return Positioned(
      right: 16,
      bottom: 100,
      child: Column(
        children: [
          FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.offset - 120,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Icon(Icons.arrow_upward),
            mini: true,
          ),
          SizedBox(height: 8),
          FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                _scrollController.offset + 120,
                duration: Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: Icon(Icons.arrow_downward),
            mini: true,
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
      appBar: AppBar(title: Text('Event Edit')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 250),
                    backgroundColor: Color.fromARGB(255,47,201,242), // Blue color for "Event Name" button
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 21,113,138),
                      width: 3.0,
                    ),
                  ),
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
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.event, size: 160, color: Colors.white), // Icon for Event Name
                    SizedBox(height: 5),
                    Text('Event Name', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold), 
                    ),
                  ],
                ),
              ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 250),
                    backgroundColor: Color.fromARGB(255, 150, 245, 124),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 17, 149, 53),
                      width: 3.0,
                    ),
                  ),
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
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.access_time_rounded, size: 160, color: Colors.white),
                    SizedBox(height: 5),
                    Text('Time/Date', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold), 
                    ),
                  ],
                ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(250, 250),
                    backgroundColor: Color.fromARGB(255,242,72,36),
                    shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Color.fromARGB(255,144,34,11),
                      width: 3.0,
                    ),
                  ),
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
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_pin, size: 160, color: Colors.white),
                    SizedBox(height: 5),
                    Text('Location', style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold), 
                    ),
                  ],
                ),
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

class EditEventPage extends StatefulWidget {
  final Event event;
  final Function(Event) updateEventCallback;

  EditEventPage({
    required this.event,
    required this.updateEventCallback,
  });

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  late TextEditingController nameController;
  late TextEditingController timeDateController;
  late TextEditingController locationController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.event.eventName);
    timeDateController = TextEditingController(text: widget.event.eventTimeDate);
    locationController = TextEditingController(text: widget.event.eventLocation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Event Name'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: timeDateController,
              decoration: InputDecoration(labelText: 'Time/Date'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: locationController,
              decoration: InputDecoration(labelText: 'Location'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Update the event and pass it back to the event list
                final updatedEvent = Event(
                  eventName: nameController.text,
                  eventTimeDate: timeDateController.text,
                  eventLocation: locationController.text,
                );

                widget.updateEventCallback(updatedEvent);
                Navigator.pop(context, updatedEvent);
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}











