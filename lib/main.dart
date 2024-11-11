import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
<<<<<<< HEAD
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const Months(title: "Months"),
=======
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Manager',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventListPage(),
>>>>>>> 04a3974768f4ba93266319c1460b32e35d1c05f1
    );
  }
}

<<<<<<< HEAD
class Months extends StatefulWidget {
  final String title; // Title field, must be initialized

  const Months({super.key, required this.title});

  @override
  MonthsState createState() => MonthsState();
}

class MonthsState extends State<Months> {
  int? selectedMonth;
  final monthsList = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];
=======
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
>>>>>>> 04a3974768f4ba93266319c1460b32e35d1c05f1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
<<<<<<< HEAD
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.70, // 70% of the screen's width
          height: MediaQuery.of(context).size.height * 0.70, // 70% of the screen's height
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 2.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 12, // 12 months
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedMonth = index;
                  });
                  if(selectedMonth != null){
                    Navigator.push( // navigate to Dates selection
                    context,
                    MaterialPageRoute(
                      builder: (context) => Dates(
                        title: "${monthsList[selectedMonth!]}.",
                        selectedMonth: selectedMonth,
                      ),
                    ),
                  );
                  }
                
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedMonth == index ? Color.fromARGB(255, 150, 245, 124) : Color.fromARGB(255, 87, 224, 124),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 17, 149, 53),
                      width: 3.0,
                      )
                  )
                ),
                child: Text(
                  monthsList[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
=======
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
>>>>>>> 04a3974768f4ba93266319c1460b32e35d1c05f1
        ),
      ),
    );
  }
}

<<<<<<< HEAD
class Dates extends StatefulWidget {
  final String title; // Title field, must be initialized
  final int? selectedMonth;
  const Dates({super.key, required this.title, required this.selectedMonth});

  @override
  DatesState createState() => DatesState();
}

class DatesState extends State<Dates> {
  int? selectedDate;
  int? selectedMonth; 
  //List<String> datesList;
  //if selectedMonth! == 1 {

  
  final datesList = [
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12", 
    "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", 
    "24", "25", "26", "27", "28", "29", "30", "31" 
  ];
=======
class EditEventPage extends StatelessWidget {
  final TextEditingController controller;
  EditEventPage({required String event}) : controller = TextEditingController(text: event);
>>>>>>> 04a3974768f4ba93266319c1460b32e35d1c05f1

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.80, // 70% of the screen's width
          height: MediaQuery.of(context).size.height * 0.70, // 70% of the screen's height
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 31, // 31 days
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedDate = index;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedDate == index ? Color.fromARGB(255, 150, 245, 124) : Color.fromARGB(255, 87, 224, 124),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 17, 149, 53),
                      width: 3.0,
                      )
                  )
                ),
                child: Text(
                  datesList[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
=======
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
>>>>>>> 04a3974768f4ba93266319c1460b32e35d1c05f1
        ),
      ),
    );
  }
}
