import 'package:flutter/material.dart';

import 'package:metacomposite_ui/listing.dart';

void main() {
  runApp(Metacomposite());
}

class Metacomposite extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metacomposite',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Listing(title: 'Metacomposite'),
    );
  }
}
