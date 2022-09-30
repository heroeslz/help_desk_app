import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:help_desck_app/api/sector.api.dart';
import 'package:help_desck_app/api/solicitations.api.dart';
import 'package:help_desck_app/models/sector.model.dart';
import 'package:help_desck_app/models/solicitation.model.dart';
import 'package:help_desck_app/pages/solicitations.page.dart';

class CreateSolicitationPage extends StatefulWidget {
  const CreateSolicitationPage({Key? key}) : super(key: key);

  @override
  State<CreateSolicitationPage> createState() => _CreateSolicitationPageState();
}

class _CreateSolicitationPageState extends State<CreateSolicitationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late bool loading = false;
  late bool loadingCreate = false;

  TextEditingController sectorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

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

  void create() async {
    setState(() {
      loadingCreate = true;
    });

    SolicitationCreateModel body = SolicitationCreateModel();
    SectorModel sectorModel = SectorModel(sector_id: sectorModelSelected["sector_id"], name: sectorModelSelected["name"]);
    body.description = descriptionController.text;
    body.sector = sectorModel;

    var response = await SolicitationApi.create(body);
    if(response.statusCode == 201) {
      setState(() {
        loadingCreate = false;
      });
      successDialog();
    }
  }

  void successDialog() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: contentBox(context),
          );
        });
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.only(
              left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Sucesso!",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Solicitação criada com sucesso!",
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SolicitationsPage()),
                      );
                    },
                    child: const Text(
                      "Fechar",
                      style: TextStyle(fontSize: 18),
                    )),
              ),
            ],
          ),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 45,
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(45)),
                child: Image.asset("assets/success.png")),
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false, //floatingActionButtonLocation fixed on bottom
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 100,
        title: const Text(
          "Solicitação",
          style: TextStyle(fontSize: 24),
        ),
        backgroundColor: Colors.black87,
      ),
      body:
      Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            decoration: const BoxDecoration(color: Colors.black87),
          ),
          loading ? SizedBox(
            height: MediaQuery.of(context).size.height / 1.3,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )  : buildForm()
        ],
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
                  if(_formKey.currentState!.validate()){
                    create();
                  }
                },
                child: loadingCreate ? const CircularProgressIndicator() : const Text(
                  'Salvar',
                  style: TextStyle(fontSize: 20),
                ),
              ))),
    );
  }

  Widget buildForm() {
    return SingleChildScrollView(
      child: form(),
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: ListView(
        shrinkWrap: true,
        children: [sectorField(), descriptionField()],
      ),
    );
  }

  Widget descriptionField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
      child: TextFormField(
        controller: descriptionController,
        style: const TextStyle(color: Colors.white),
        maxLines: 8,
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
          errorStyle: const TextStyle(color: Colors.white, fontSize: 18),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.0),
            borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
          ),
          hintText: 'Descrição do problema',
        ),
        validator: (String? value) {
          if (value!.isEmpty) {
            return 'Informe uma descrição';
          } else if (value.length < 5) {
            return 'A descrição deve ter mais de 5 caracteres';
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
                child: containerSector(context),
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
          errorStyle: const TextStyle(color: Colors.white, fontSize: 18),
          hintText: 'Setor onde está o problema',
        ),
        validator: (String? value) {
          if (value == null || value.isEmpty) {
            return 'Informe o setor do problema';
          }
          return null;
        },
      ),
    );
  }

  Widget containerSector(context){
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.loose,
      children: [
        Container(
          width: screenWidth,
          height: 300,
          padding: const EdgeInsets.only(
              left: 20, top: 20, right: 20, bottom: 20),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFF22223b),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]
          ),
          child: Column(
            children: [
              const Padding(padding: EdgeInsets.all(10), child: Text("Selecione o setor",
                style: TextStyle(color: Colors.white, fontSize: 20.0),),),
              ListView.builder(
                itemCount: data.length,
                shrinkWrap: true,
                itemBuilder: (BuildContext context, int index) {
                  dynamic resp = data[index];
                  return RadioListTile<dynamic>(
                    title: Text(resp["name"], style: const TextStyle(color: Colors.white),),
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
          )
        ),
      ],
    );
  }
}
