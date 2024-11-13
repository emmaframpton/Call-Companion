import 'dart:developer';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Call Companion',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Months(title: "Months"),
    );
  }
}

class Months extends StatefulWidget {
  final String title; // Title field, must be initialized

  const Months({super.key, required this.title});

  @override
  MonthsState createState() => MonthsState();
}

class MonthsState extends State<Months> {
  String? selectedMonth;
  final monthsList = [
    "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
  ];

  @override
  Widget build(BuildContext context) {
    int numColumns = 3;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 350) {
      numColumns = 2;
    } else if (screenWidth > 600) {
      numColumns = 4;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.70, // 70% of the screen's width
          height: MediaQuery.of(context).size.height * 0.70, // 70% of the screen's height
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numColumns,
              childAspectRatio: 2.0,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: 12, // 12 months
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  selectedMonth = monthsList[index]; 

                  if (selectedMonth != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Dates(
                          title: "$selectedMonth", //
                          selectedMonth: selectedMonth,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedMonth == monthsList[index]
                      ? Color.fromARGB(255, 150, 245, 124)
                      : Color.fromARGB(255, 87, 224, 124),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 17, 149, 53),
                      width: 3.0,
                    ),
                  ),
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
        ),
      ),
    );
  }
}


class Dates extends StatefulWidget {
  final String title; // Title field, must be initialized
  final String? selectedMonth;
  const Dates({super.key, required this.title, required this.selectedMonth});

  @override
  DatesState createState() => DatesState();
}

class DatesState extends State<Dates> {
  int? selectedDate;
  String? selectedMonth; // Declare selectedMonth

  final datesList = [
    "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11", "12",
    "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23",
    "24", "25", "26", "27", "28", "29", "30", "31"
  ];

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.selectedMonth; // Initialize selectedMonth with the passed value
  }

  @override
  Widget build(BuildContext context) {
    int numColumns = 7;
    double screenWidth = MediaQuery.of(context).size.width;

    if (screenWidth < 600) {
      numColumns = 4;
    } else if (screenWidth > 800) {
      numColumns = 7;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.80, // 80% of the screen's width
          height: MediaQuery.of(context).size.height * 0.70, // 70% of the screen's height
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numColumns,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 31, // 31 days
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  selectedDate = index + 1; 
                  
                  if (selectedDate != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Hours(
                          title: "$selectedMonth $selectedDate",
                          selectedMonth: selectedMonth,
                          selectedDate: selectedDate,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedDate == index + 1
                      ? Color.fromARGB(255, 150, 245, 124)
                      : Color.fromARGB(255, 87, 224, 124),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 17, 149, 53),
                      width: 3.0,
                    ),
                  ),
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
        ),
      ),
    );
  }
}


class Hours extends StatefulWidget {
  final String title; // Title field, must be initialized
  final String? selectedMonth;
  final int? selectedDate;
  const Hours({super.key, required this.title, required this.selectedMonth, required this.selectedDate});

  @override
  HoursState createState() => HoursState();
}

class HoursState extends State<Hours> {
  String? selectedMonth;
  int? selectedDate;
  int? selectedHour; 
  
  final hoursList = [
    "1:", "2:", "3:", "4:", "5:", "6:", "7:", "8:", "9:", "10:", "11:", "12:", 
  ];

  @override
  Widget build(BuildContext context) {
    int numColumns = 3;
    double screenWidth = MediaQuery.of(context).size.width;
    
log('Selected Month: $selectedMonth');
log('Selected Date: $selectedDate');
log('Selected Hour: $selectedHour');

    if (screenWidth < 350) {
      numColumns = 2;
    } else if (screenWidth > 600) {
      numColumns = 4;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.70, // 70% of the screen's width
          height: MediaQuery.of(context).size.height * 0.50, // 70% of the screen's height
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: numColumns,
              childAspectRatio: 1.0,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 12, // 12 hours
            itemBuilder: (context, index) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    selectedHour = index;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedHour == index ? Color.fromARGB(255, 150, 245, 124) : Color.fromARGB(255, 87, 224, 124),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(
                      color: Color.fromARGB(255, 17, 149, 53),
                      width: 3.0,
                      )
                  )
                ),
                child: Text(
                  hoursList[index],
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
