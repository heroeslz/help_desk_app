import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_desck_app/api/sector.api.dart';
import 'package:help_desck_app/api/user.api.dart';
import 'package:help_desck_app/models/sector.model.dart';
import 'package:help_desck_app/models/user.dart';
import 'package:help_desck_app/pages/admin.dart';
import 'package:help_desck_app/widgets/dialog.dart';
import 'package:help_desck_app/widgets/email.dart';
import 'package:help_desck_app/widgets/password.dart';
import 'package:help_desck_app/widgets/sectorField.dart';
import 'package:help_desck_app/widgets/userName.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);

  @override
  State<CreateUser> createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController sectorController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final ValueNotifier<dynamic> sectorFinal = ValueNotifier<dynamic>('');

  late bool loading = false;
  late bool loadingCreate = false;
  dynamic sectorModelSelected;
  late Future<dynamic> sectorOptions;
  List data = [];

  void getSectors() async {
    setState(() {
      loading = true;
    });
    var response = await SectorApi.getSectors();

    var resBody = json.decode(response.body);
    setState(() {
      data = resBody["sectors"];
      loading = false;
    });
  }

  createAccount() async {
    setState(() {
      loadingCreate = true;
    });

    UserModel body = UserModel();
    SectorModel sectorModel = SectorModel(
        sector_id: sectorFinal.value["sector_id"],
        name: sectorFinal.value["name"]);
    body.sector = sectorModel;
    body.email = emailController.text;
    body.password = passwordController.text;
    body.name = nameController.text;
    body.user_type = 'ADMIN';

    var response = await UserApi.createAccount(body);
    var jsonResponse = json.decode(response.body);
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
              'Fechar', true);
        }).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const AdminPage()),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    getSectors();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,
        title: const Text(
          "Novo usuário",
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Colors.black87,
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
            width: screenWidth,
            padding: const EdgeInsets.all(10),
            child: SizedBox(
                width: screenWidth,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen[900],
                  ),
                  onPressed: () {
                    if(loadingCreate){
                      null;
                    }else if (_formKey.currentState!.validate()) {
                      createAccount();
                    }
                  },
                  child: loadingCreate
                      ? const CircularProgressIndicator()
                      : const Text(
                    'Salvar',
                    style: TextStyle(fontSize: 20),
                  ),
                ))),
    body: Stack(
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
          decoration: const BoxDecoration(color: Colors.black87),
        ),
        buildForm()
      ],
    )
    );
  }

  Widget buildForm() {
    return form();
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [   nameField(nameController),
          emailField(emailController),
          passwordField(passwordController),
          ValueListenableBuilder(
              valueListenable: sectorFinal,
              builder: (context, _content, child) {
                return sectorField(sectorController, context, sectorFinal, data, loading);
              })
        ],
      ),
    );
  }
}
