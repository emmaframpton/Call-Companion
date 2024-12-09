import 'package:flutter/material.dart';

class Location extends StatefulWidget {
  final Function(String) updateLocationCallback;

  const Location({super.key, required this.updateLocationCallback});

  @override
  LocationState createState() => LocationState();
}

class LocationState extends State<Location> {
  final TextEditingController controller = TextEditingController();
  
  // Define event-based locations
  final Map<String, List<String>> eventLocations = {
    "Doctor's Appointment": [
      "Hospital",
      "Clinic",
      "Health Center",
      "Medical Office"
    ],
    "Dentist Appointment": [
      "Dental Office",
      "Dentist's Clinic",
      "Orthodontist's Office"
    ],
    "Physical Therapy (PT)": [
      "Physical Therapy Clinic",
      "Rehab Center",
      "Sports Medicine Center"
    ],
    "Occupational Therapy (OT)": [
      "Occupational Therapy Center",
      "Rehab Center",
      "Therapy Office"
    ],
    "Meeting": [
      "Conference Room",
      "Office",
      "Coffee Shop",
      "Co-working Space"
    ],
    "Hangout": [
      "Café",
      "Park",
      "Movie Theater",
      "Restaurant",
      "Mall"
    ]
  };

  List<String> selectedLocations = [];

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
      appBar: AppBar(title: Text('Select Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for selecting event
            DropdownButton<String>(
              hint: Text("Select Event"),
              items: eventLocations.keys.map((String event) {
                return DropdownMenuItem<String>(
                  value: event,
                  child: Text(event),
                );
              }).toList(),
              onChanged: (selectedEvent) {
                if (selectedEvent != null) {
                  setState(() {
                    selectedLocations = eventLocations[selectedEvent]!;
                  });
                }
              },
            ),
            SizedBox(height: 10),
            
            // Display available locations as buttons based on selected event
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: numColumns,
                  childAspectRatio: 1.0,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: selectedLocations.length,
                itemBuilder: (context, index) {
                  return ElevatedButton(
                    onPressed: () {
                      widget.updateLocationCallback(selectedLocations[index]);
                      Navigator.popUntil(context, (route) {
                        return route.settings.name == '/newEventPage';
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255,	164	,10	,10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(
                          color: Color.fromARGB(255,	91,	6	,6),
                          width: 3.0,
                        ),
                      ),
                    ),
                    child: Text(
                      selectedLocations[index],
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: 'Add Custom Location'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255,	164	,10	,10),
              ),
              onPressed: () {
                final customLocation = controller.text.trim();
                if (customLocation.isNotEmpty && !selectedLocations.contains(customLocation)) {
                  setState(() {
                    selectedLocations.add(customLocation);
                  });
                  controller.clear();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Custom location added!')),
                  );
                }
              },
              child: Text(
                'Add Custom Location',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
