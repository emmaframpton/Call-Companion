import 'package:flutter/material.dart';

class CreateCustomEvent extends StatefulWidget {
  @override
  _CreateCustomEventState createState() => _CreateCustomEventState();
}

class _CreateCustomEventState extends State<CreateCustomEvent> {
  final TextEditingController _eventNameController = TextEditingController();
  IconData? _selectedIcon;

  final List<IconData> _availableIcons = [
    Icons.medical_services,
    Icons.face,
    Icons.fitness_center,
    Icons.work,
    Icons.group,
    Icons.coffee,
    Icons.local_hospital,
    Icons.add_circle,
    Icons.calendar_today,
    Icons.access_alarm,
    Icons.accessibility,
    Icons.healing,
    Icons.phonelink_ring,
    Icons.nordic_walking,
    Icons.spa,
    Icons.schedule,
    Icons.favorite,
    Icons.notifications,
    Icons.alarm,
    Icons.assignment_turned_in,
    Icons.book_online,
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Custom Event')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // custom event name
            TextField(
              controller: _eventNameController,
              decoration: InputDecoration(
                labelText: 'Enter event name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // display available icons in a horizontally scrollable list
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _availableIcons.map((icon) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIcon = icon;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(right: 10), // space between icons
                      width: 50, // smaller width for rounded box
                      height: 50, // smaller height for rounded box
                      decoration: BoxDecoration(
                        color: _selectedIcon == icon ? Colors.blue : Colors.grey,
                        borderRadius: BorderRadius.circular(12), // Rounded corners
                      ),
                      child: Icon(
                        icon,
                        color: Colors.white,
                        size: 25, // icon size
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String customEventName = _eventNameController.text.trim();
                if (customEventName.isNotEmpty && _selectedIcon != null) {
                  // return custom event name and the selected icon to the previous screen
                  Navigator.pop(context, {'name': customEventName, 'icon': _selectedIcon});
                } else {
                  // show a dialog if no name or icon is selected
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("Please enter a name and select an icon."),
                  ));
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
                    Icons.add, // icon for the button
                    size: 40,
                    color: Colors.white,
                  ),
                  Text(
                    'Create Event',
                    style: TextStyle(
                      fontSize: 18,
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
