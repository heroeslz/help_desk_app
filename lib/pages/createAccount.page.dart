import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:help_desck_app/api/sector.api.dart';
import 'package:help_desck_app/api/user.api.dart';
import 'package:help_desck_app/models/sector.model.dart';
import 'package:help_desck_app/models/user.dart';
import 'package:help_desck_app/pages/login.page.dart';
import 'package:help_desck_app/widgets/dialog.dart';
import 'package:help_desck_app/widgets/email.dart';
import 'package:help_desck_app/widgets/password.dart';
import 'package:help_desck_app/widgets/sectorField.dart';
import 'package:help_desck_app/widgets/userName.dart';

class CreateAccountPage extends StatefulWidget {
  const CreateAccountPage({Key? key}) : super(key: key);

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  late bool loading = false;
  late bool loadingCreate = false;
  late bool comunUser = true;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  createAccount() async {
    setState(() {
      loadingCreate = true;
    });

    UserModel body = UserModel();
    body.email = emailController.text;
    body.password = passwordController.text;
    body.name = nameController.text;
    body.user_type = 'USER';


    var response = await UserApi.createAccount(body);
    var jsonResponse = json.decode(response.body);
    if (kDebugMode) {print(jsonResponse);}

    if (response.statusCode == 412) {
      setState(() {
        loadingCreate = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Email já cadastrado')));
    } else if (response.statusCode == 201) {
      setState(() {
        loadingCreate = false;
      });
      messageDialog();
    }
  }

  void messageDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return customDialog(context, 'Sucesso!', 'Conta criada com sucesso!',
              'Fazer login', true);
        }).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            decoration: const BoxDecoration(color: Colors.black87),
          ),
          buildForm()
        ],
      ),
    );
  }

  Widget buildForm() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 10.0),
      alignment: Alignment.center,
      child: Center(
        child: ListView(
          children: [circleImage(), form(), loginButton(), loginPage()],
        ),
      ),
    );
  }

  Widget circleImage() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        width: screenWidth,
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Ceuma Desk",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  decoration: TextDecoration.none),
            ),
            SizedBox(
              width: 300,
              child: Image.asset("assets/ceuma.png"),
            ),
          ],
        ));
  }

  Widget form() {
    return Column(
      children: [
        const Text(
          "Criar conta",
          textAlign: TextAlign.center,
          style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w400,
              decoration: TextDecoration.none),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              nameField(nameController),
              emailField(emailController),
              passwordField(passwordController),
            ],
          ),
        ),
      ],
    );
  }



  Widget loginButton() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        width: screenWidth,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: SizedBox(
            width: screenWidth,
            height: 60,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreen[900],
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  createAccount();
                }
              },
              child: loadingCreate
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'Salvar',
                      style: TextStyle(fontSize: 20),
                    ),
            )));
  }

  Widget loginPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        width: screenWidth,
        alignment: Alignment.center,
        child: TextButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Login()),
            );
          },
          child: const Text(
            'Fazer login',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ));
  }
}
