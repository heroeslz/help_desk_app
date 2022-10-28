import 'package:flutter/material.dart';
import 'package:help_desck_app/pages/sectors.page.dart';
import 'package:help_desck_app/pages/solicitations.page.dart';
import 'package:help_desck_app/pages/users.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({Key? key}) : super(key: key);

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        title: const Text(
          "Administrador",
          style: TextStyle(fontSize: 30),
        ),
        bottom: const TabBar(
          tabs: [
            Tab(text: "Setores"),
            Tab(text: "Usuários"),
          ],
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
      body: const TabBarView(
        children: [
          SectorsPage(),
          UsersPage(),
        ],
      ),
    ));
  }
}
