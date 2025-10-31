import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/swimmer_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouCanOtoWenIt',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SwimmerListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
