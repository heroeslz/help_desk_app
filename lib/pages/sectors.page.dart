import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:help_desck_app/api/sector.api.dart';
import 'package:help_desck_app/models/solicitation.model.dart';
import 'package:help_desck_app/pages/solicitations.page.dart';

class SectorsPage extends StatefulWidget {
  const SectorsPage({Key? key}) : super(key: key);

  @override
  State<SectorsPage> createState() => _SectorsPageState();
}

class _SectorsPageState extends State<SectorsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  late bool loading = false;
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

  void createSector() async {
    setState(() {
      loading = true;
    });

    SectorCreateModel sector = SectorCreateModel();
    sector.name = nameController.text;
    var response = await SectorApi.createSector(sector);

    if (response.statusCode == 201) {
      nameController.text = "";
      getSectors();
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Falha ao criar o setor')));
    }
  }

  @override
  void initState() {
    super.initState();
    getSectors();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        title: const Text(
          "Setores",
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.green,
              size: 30,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SolicitationsPage()),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            decoration: const BoxDecoration(color: Colors.black87),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              newSector(),
              Expanded(child: sectorsList())
            ],
          )
        ],
      ),
    );
  }


  Widget newSector() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: const EdgeInsets.only(top: 4.0),
      padding: const EdgeInsets.fromLTRB(12.0, 10.0, 12.0, 10.0),
      width: screenWidth,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              width: screenWidth * 0.8,
              child: Form(
                key: _formKey,
                child: nameField(),
              )),
          const Spacer(), // use Spacer
          CircleAvatar(
              backgroundColor: Colors.greenAccent[900],
              child: IconButton(
                icon: const Icon(
                  Icons.add,
                  color: Color(0xfffca311),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    createSector();
                  }
                },
              )),
        ],
      ),
    );
  }

  Widget nameField() {
    return TextFormField(
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
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.transparent, width: 0.0),
        ),
        errorStyle: const TextStyle(color: Colors.white, fontSize: 18),
        hintText: 'Nome do setor...',
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Informe o nome do setor';
        }
        return null;
      },
    );
  }

  Widget sectorsList() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        padding: const EdgeInsets.fromLTRB(12.0, 1.0, 12.0, 10.0),
        width: screenWidth,
        alignment: Alignment.center,
        child: loading
            ? SizedBox(
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            :  ListView.builder(
            padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
            itemCount: data.length,
            shrinkWrap: false,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                color: const Color(0xff333533),
                elevation: 1,
                child: ClipPath(
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 2.0),
                          child: Text(
                            "${data[index]["name"]}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    ),
                  ),
                ),
              );
            })
    );
  }
}
