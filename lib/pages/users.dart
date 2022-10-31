import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:help_desck_app/api/sector.api.dart';
import 'package:help_desck_app/api/user.api.dart';
import 'package:help_desck_app/models/solicitation.model.dart';
import 'package:help_desck_app/pages/create_user.dart';
import 'package:help_desck_app/widgets/dialog.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _SectorsPageState();
}

class _SectorsPageState extends State<UsersPage> {
  late bool loading = false;
  List data = [];

  void getUser() async {
    setState(() {
      loading = true;
    });
    var response = await UserApi.getUsers();
    var resBody = json.decode(response.body);

    print(resBody);
    setState(() {
      data = resBody["users"];
      loading = false;
    });
  }


  void deleteUser(id) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Deletar Usuário'),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Você deseja deletar este usuário?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Sim'),
                onPressed: () {
                  Navigator.of(context).pop();
                  confirmDeleteUser(id);
                },
              ),
              TextButton(
                child: const Text('Não'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void confirmDeleteUser(id) async {
    setState(() {
      loading = true;
    });

    var response = await UserApi.deleteUser(id);
    var resBody = json.decode(response.body);

    setState(() {
      loading = false;
    });
    if(resBody["type"] == "USER_CANNOT_BE_DELETED"){
      messageDialog('Atenção', 'Usuário não pode ser deletado', false);
    }else{
      messageDialog('Sucesso!', 'Usuário deletado com sucesso', true);
    }
  }

  void messageDialog(String title, String text, bool success) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return customDialog(context, title, text,
              'Fechar', success);
        }).then((value) => {
          if(success)getUser()
    });
  }

  @override
  void initState() {
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateUser()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
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
              Expanded(child: usersList())
            ],
          )
        ],
      ),
    );
  }

  Widget usersList() {
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
                        Padding(
                          padding:
                          const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 2.0),
                          child: Text(
                            "Tipo: ${data[index]["user_type"]}",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.redAccent,
                      ),
                      onPressed: () {
                        deleteUser(data[index]["user_id"]);
                      },
                    )
                  ),
                ),
              );
            })
    );
  }
}
