import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:help_desck_app/pages/login.page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Future.delayed(const Duration(seconds: 1)).then((_){
      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            decoration: const BoxDecoration(color: Colors.black87),
          ),
          Center(
            child: Container(
              width: screenWidth,
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: screenWidth * 0.6,
                child: Image.asset("assets/ceuma.png"),
              ),),
          )
        ],
      ),
    );
  }
}
