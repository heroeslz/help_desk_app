import 'package:flutter/material.dart';

Widget passwordField(passwordController) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
    child: TextFormField(
      controller: passwordController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintStyle: const TextStyle(fontSize: 20.0, color: Colors.white),
        fillColor: const Color.fromARGB(80, 0, 0, 0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
        ),
        errorStyle: const TextStyle(color: Colors.white, fontSize: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
        ),
        prefixIcon: Icon(
          Icons.key_rounded,
          color: Colors.lightGreen[900],
        ),
        hintText: 'Senha',
      ),
      validator: (String? value) {
        if (value!.isEmpty) {
          return 'Informe uma senha';
        } else if (value.length < 6) {
          return 'Senha deve ter mais de 6 caracteres';
        }
        return null;
      },
    ),
  );
}