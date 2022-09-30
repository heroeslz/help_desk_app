import 'package:flutter/material.dart';
import 'package:help_desck_app/api/user.api.dart';
import 'package:help_desck_app/models/user.dart';
import 'package:help_desck_app/pages/createAccount.page.dart';
import 'package:help_desck_app/pages/solicitations.page.dart';
import 'package:help_desck_app/widgets/dialog.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late bool loading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void login() async {
    setState(() {
      loading = true;
    });

    UserRequest userRequest = UserRequest();

    userRequest.email = emailController.text;
    userRequest.password = passwordController.text;

    var response = await UserApi.login(userRequest);

    if(response.statusCode == 201){
      setState(() {
        loading = false;
        emailController.text = "";
        passwordController.text = "";
      });
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SolicitationsPage()),
      );
    }else if(response.statusCode == 403){
      setState(() {
        passwordController.text = "";
        loading = false;
      });
      invalidCredentials();
    }
  }

  void invalidCredentials() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return customDialog(context, 'Atenção!',
              'Usuário e/ou senha incorretos', 'Fechar', false);
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
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            circleImage(),
            form(),
            loginButton(),
            createAccountPage()
          ],
        ),
      ),
    );
  }

  Widget circleImage() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(bottom: 30),
      width: screenWidth,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Padding(padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 4.0),child: Image.network("https://www.extranet.ceuma.br/hotsite/img/logo.png"),),
          const Text(
            "Ceuma Desk",
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white, fontSize: 20, decoration: TextDecoration.none),
          ),
        ],
      )
    );
  }

  Widget form() {
    return Column(
      children:  [
        const Text(
          "Acesse sua conta",
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
          child: ListView(
              shrinkWrap: true,
            children: [
              emailField(),
              passwordField()
            ],
          ),
        ),
      ],
    );
  }

  Widget emailField(){
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
          if (value == null || value.isEmpty) {
            return 'Informe seu email';
          }
          return null;
        },
      ),
    );
  }

  Widget passwordField(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
      child: TextFormField(
        controller: passwordController,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintStyle: const TextStyle(fontSize: 20.0, color: Colors.white),
          fillColor: const Color.fromARGB(80, 0, 0, 0),
          filled: true,
          errorStyle: const TextStyle(color: Colors.white, fontSize: 18),
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
            Icons.key_rounded,
            color: Colors.lightGreen[900],
          ),
          hintText: 'Senha',
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Informe sua senha';
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
        margin: const EdgeInsets.all(10),
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
                if(_formKey.currentState!.validate()){
                  login();
                }
              },
              child: loading ?  const CircularProgressIndicator(
                valueColor:AlwaysStoppedAnimation<Color>(Colors.white),
              ) : const Text('Entrar', style: TextStyle(fontSize: 20),),
            )
        )
    );
  }

  Widget createAccountPage() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        width: screenWidth,
        padding: const EdgeInsets.all(10),
        alignment: Alignment.center,
        child: TextButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CreateAccountPage()),
            );
          },
          child: const Text('Criar conta', style: TextStyle(fontSize: 20, color: Colors.white),),
        )
    );
  }
}
