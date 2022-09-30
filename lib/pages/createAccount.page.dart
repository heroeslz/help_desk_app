import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:help_desck_app/api/sector.api.dart';
import 'package:help_desck_app/api/user.api.dart';
import 'package:help_desck_app/models/sector.model.dart';
import 'package:help_desck_app/models/user.dart';
import 'package:help_desck_app/pages/login.page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:help_desck_app/widgets/dialog.dart';

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
  TextEditingController sectorController = TextEditingController();
  TextEditingController userTypeController = TextEditingController();

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

  Widget selectSector(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(
          width: screenWidth,
          height: 300,
          padding:
              const EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFF22223b),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Selecione o setor",
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
              ),
              ListView.builder(
                itemCount: data.length,
                shrinkWrap: true, // <-- Set this to true
                itemBuilder: (BuildContext context, int index) {
                  dynamic resp = data[index];
                  return RadioListTile<dynamic>(
                    title: Text(
                      resp["name"],
                      style: const TextStyle(color: Colors.white),
                    ),
                    value: resp,
                    groupValue: sectorModelSelected,
                    onChanged: (dynamic value) {
                      setState(() {
                        sectorModelSelected = value;
                        sectorController.text = value["name"];
                        Navigator.pop(context);
                      });
                    },
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getSectors();
  }

  createAccount() async {
    setState(() {
      loadingCreate = true;
    });

    UserModel body = UserModel();
    SectorModel sectorModel = SectorModel(
        sector_id: sectorModelSelected["sector_id"],
        name: sectorModelSelected["name"]);
    body.sector = sectorModel;
    body.email = emailController.text;
    body.password = passwordController.text;
    body.name = nameController.text;
    body.user_type = comunUser ? 'USER' : 'ADMIN';

    var response = await UserApi.createAccount(body);

    if (response.statusCode == 412) {
      setState(() {
        loadingCreate = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Email já cadastrado')));
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
          loading
              ? SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : buildForm()
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),
              child: Image.network(
                  "https://www.extranet.ceuma.br/hotsite/img/logo.png"),
            ),
            const Text(
              "Ceuma Desk",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  decoration: TextDecoration.none),
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
              nameField(),
              emailField(),
              passwordField(),
              sectorField(),
              SwitchListTile(
                title: const Text(
                  'Usuário comum',
                  style: TextStyle(color: Colors.white),
                ),
                value: comunUser,
                onChanged: (bool value) {
                  setState(() {
                    comunUser = value;
                  });
                },
                secondary: const Icon(Icons.person, color: Colors.green),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget emailField() {
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

  Widget nameField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
      child: TextFormField(
        controller: nameController,
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
            Icons.person,
            color: Colors.lightGreen[900],
          ),
          hintText: 'Nome',
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Informe seu nome';
          } else if (value.length < 6) {
            return 'Nome deve ter mais de 6 caracteres';
          }
          return null;
        },
      ),
    );
  }

  Widget passwordField() {
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

  Widget sectorField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
      child: TextFormField(
        readOnly: true,
        controller: sectorController,
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 0,
                backgroundColor: Colors.transparent,
                child: selectSector(context),
              );
            }),
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
          prefixIcon: Icon(
            Icons.edit_location,
            color: Colors.lightGreen[900],
          ),
          errorStyle: const TextStyle(color: Colors.white, fontSize: 18),
          hintText: 'Setor',
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Informe seu setor';
          }
          return null;
        },
      ),
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
