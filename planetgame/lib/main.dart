import 'package:flutter/material.dart';
import 'login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Fix the constructor syntax

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Planetgame',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: const Login(),
      ),
      // Change home to MyHomePage
    );
  }
}

class MyAppState extends ChangeNotifier {
  @override
  void notifyListeners() {
    super.notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key}); // Fix the constructor syntax

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold widget is required for build method
      appBar: AppBar(
        title: const Text('Home Page'), // Set app bar title
      ),
      body: const Center(
        child: Text('Welcome to Planet Game!'), // Display some text
      ),
    );
  }
}
