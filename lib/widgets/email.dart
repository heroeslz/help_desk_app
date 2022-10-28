import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';

Widget emailField(emailController) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
    child: TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintStyle: const TextStyle(fontSize: 20.0, color: Colors.white),
        fillColor: const Color.fromARGB(80, 0, 0, 0),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
        ),
        errorStyle: const TextStyle(color: Colors.white, fontSize: 18),
        prefixIcon: Icon(
          Icons.email,
          color: Colors.lightGreen[900],
        ),
        hintText: 'E-mail',
      ),
      validator: (String? value) {
        final bool isValid = EmailValidator.validate(value!);
        if (value.isEmpty) {
          return 'Informe um email';
        } else if (isValid == false) {
          return 'Informe um email válido';
        }
        return null;
      },
    ),
  );
}