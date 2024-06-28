import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier Conversion'),
      ),
      body: Center(
        child: Container(
          width: 342,
          height: 130,
          padding: EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Color(0x0F101828).withOpacity(0.1), // Adjust opacity if necessary
                spreadRadius: 1,
                blurRadius: 2,
                offset: Offset(0, 2),
              ),
              BoxShadow(
                color: Color(0x1A101828).withOpacity(0.1), // Adjust opacity if necessary
                spreadRadius: 1,
                blurRadius: 3,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'Converted Container',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}
