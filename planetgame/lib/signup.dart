import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Reusableloginwidget.dart';
import 'planetchoice.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _playerNameTextController =
      TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  Future<void> _signup(BuildContext context) async {
    final url = Uri.parse('http://192.168.0.106:4000/api/signup');

    final response = await http.post(
      url,
      body: json.encode({
        'PlayerName': _playerNameTextController.text,
        'Email': _emailTextController.text,
        'Password': _passwordTextController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      String userEmail = _emailTextController.text;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Planetchoice(userEmail: userEmail),
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.thumb_up, color: Colors.deepOrange[300]),
              const SizedBox(width: 30),
              const Text(
                'Signup Successful',
                style: TextStyle(color: Colors.green),
              ),
            ],
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.black.withOpacity(0.5),
        ),
      );
    } else {
      print('Failed to signup: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Text(
            'Sign Up',
            style: TextStyle(color: Colors.white),
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            const Color.fromARGB(255, 27, 94, 32).withOpacity(0.9),
            Colors.green.withOpacity(0.9),
          ])),
        ),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color.fromARGB(255, 27, 94, 32).withOpacity(0.9),
                Colors.green.withOpacity(0.9),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: reusableTextField('enter playername', false,
                    Icons.person_2_outlined, _playerNameTextController),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: reusableTextField('enter email', false,
                    Icons.email_rounded, _emailTextController),
              ),
              const SizedBox(
                height: 8,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: reusableTextField('enter password', true,
                    Icons.password_outlined, _passwordTextController),
              ),
              const SizedBox(
                height: 13,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: loginButton(false, () {
                  _signup(context);
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
