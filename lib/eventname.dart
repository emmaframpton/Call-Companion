import 'package:flutter/material.dart';
import 'main.dart';
import 'createcustomevent.dart';

class EventName extends StatefulWidget {
  final Function(String) updateEventNameCallback;

  const EventName({super.key, required this.updateEventNameCallback});

  @override
  EventNameState createState() => EventNameState();
}

class EventNameState extends State<EventName> {
  final List<String> eventNames = [
    "Doctor's Appointment",
    "Dentist Appointment",
    "Physical Therapy (PT)",
    "Occupational Therapy (OT)",
    "Meeting",
    "Hangout"
  ];

  final List<IconData> eventIcons = [
    Icons.medical_services,
    Icons.face,
    Icons.fitness_center,
    Icons.work,
    Icons.group,
    Icons.coffee,
  ];

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int numColumns = 2;
    double fontSize = 18;

    if (screenWidth < 300) {
      numColumns = 1;
      fontSize = 14;
    } else if (screenWidth < 500) {
      numColumns = 2;
      fontSize = 16;
    } else if (screenWidth < 650) {
      numColumns = 3;
      fontSize = 18;
    } else if (screenWidth > 650) {
      numColumns = 4;
      fontSize = 20;
    }

    return Scaffold(
      appBar: AppBar(title: Text('Select Event Name')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numColumns,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: eventNames.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () async {
                      widget.updateEventNameCallback(eventNames[index]);
                      Navigator.popUntil(context, (route) {
                        return route.settings.name == '/newEventPage';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 47, 201, 242),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Color.fromARGB(255, 21, 113, 138),
                          width: 3.0,
                        ),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          eventIcons[index],
                          size: 40,
                          color: Colors.white,
                        ),
                        Text(
                          eventNames[index],
                          style: TextStyle(
                            fontSize: fontSize,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                // Navigate to the custom event creation page
                String customEventName = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreateCustomEvent(),
                  ),
                );

                if (customEventName.isNotEmpty) {
                  widget.updateEventNameCallback(customEventName);
                  Navigator.popUntil(context, (route) {
                    return route.settings.name == '/newEventPage';
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                fixedSize: Size(250, 80),
                backgroundColor: Color.fromARGB(255, 47, 201, 242),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(
                    color: Color.fromARGB(255, 21, 113, 138),
                    width: 3.0,
                  ),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add, // Icon for "Create Event"
                    size: 40,
                    color: Colors.white,
                  ),
                  Text(
                    'Create Custom Event',
                    style: TextStyle(
                      fontSize: fontSize,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
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
