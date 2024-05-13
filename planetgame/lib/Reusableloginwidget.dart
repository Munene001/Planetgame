import 'package:flutter/material.dart';

Widget reusableTextField(String text, bool isPasswordType, IconData icon,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white30,
    style: TextStyle(
      color: Colors.white.withOpacity(0.9),
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(icon, color:Colors.deepOrange.shade700),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white70.withOpacity(0.9),),
      filled: true,
      fillColor: Colors.white.withOpacity(0.3),
      floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0),
            borderSide: BorderSide(
              color: Colors.white70.withOpacity(0.9),
              width: 1.0,
            ))),
  );
}

Container loginButton( bool isLogin, Function onTap) {
  return Container(
    height: 48,
    width: 500,
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
    
      child: ElevatedButton(
          onPressed: () {
            onTap();
          },
          child: Text(
            isLogin ? "LOGIN" : "SIGNUP",
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          )),
    );
}
