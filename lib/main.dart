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
      home: const Months(title: "Months"),
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
  int? selectedMonth;
  final monthsList = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title), 
        ),
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.70 , // 70% of the screen's width
            height: MediaQuery.of(context).size.height * 0.70) ,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                childAspectRatio: 2.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
                ),
                itemCount: 12, // 12 months
            ,)
          )
    );
  }
}