import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'Reusableloginwidget.dart';
import 'main.dart';
import 'signup.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final url = Uri.parse('http://192.168.0.106:4000/api/login');
    final response = await http.post(
      url,
      body: jsonEncode({
        'Email': _emailTextController.text,
        'Password': _passwordTextController.text,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 500){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(
            children: [
              Icon(Icons.thumb_down, color: Colors.deepOrange[300]),
              const SizedBox(
                width: 30,
              ),
              const Text('Cant retrieve id')
            ],
          ),
          duration: const Duration(seconds: 1),
          backgroundColor: Colors.black.withOpacity(0.5)


      ));

    }
    if (response.statusCode == 201) {

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MyHomePage()));
    } else if(response.statusCode == 401) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: [
            Icon(Icons.thumb_down, color: Colors.deepOrange[300]),
            const SizedBox(
              width: 30,
            ),
            const Text('what the fuck')
          ],
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: Colors.black.withOpacity(0.5)
    

      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 0, 0),
          child: Text('Login', style: TextStyle(color: Colors.white),),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              const Color.fromARGB(255, 27, 94, 32).withOpacity(0.9),
                Colors.green.withOpacity(0.9),

            ])

          ),

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
                child: reusableTextField(
                    'enter email', false, Icons.email, _emailTextController),
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
                child: loginButton(true, () {
                  _login(context);
                }),
              ),
              const SizedBox(height: 7),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 90.0),
                child: signupField(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget signupField(BuildContext context) {
  return Row(
    children: [
      const Text(
        "Don't have an account?|",
        style: TextStyle(color: Colors.white, fontSize: 15),
      ),
      GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Signup()));
        },
        child: const Text("Sign Up",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            )),
      )
    ],
  );
}
