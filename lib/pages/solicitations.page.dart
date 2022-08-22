import 'package:flutter/material.dart';
import 'package:help_desck_app/api/solicitations.api.dart';
import 'package:help_desck_app/pages/createSolicitation.page.dart';
import 'package:help_desck_app/pages/login.page.dart';
import 'package:help_desck_app/pages/solicitationDetail.page.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SolicitationsPage extends StatefulWidget {
  const SolicitationsPage({Key? key}) : super(key: key);

  @override
  State<SolicitationsPage> createState() => _SolicitationsState();
}

class _SolicitationsState extends State<SolicitationsPage> {
  late bool closeSolicitations = true;

  late int sizeList = 0;
  late Future<dynamic> solicitations;

  getSolicitationsOpen() {
    setState(() {
      closeSolicitations = true;
      solicitations = SolicitationApi.getSolicitationsOpen();
    });
  }

  getSolicitationsClose() {
    setState(() {
      closeSolicitations = false;
      solicitations = SolicitationApi.getSolicitationsClose();
    });
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Login()),
    );
  }

  @override
  void initState() {
    super.initState();
    getSolicitationsOpen();
  }

  createSolicitation() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateSolicitationPage()),
    );
  }

  formatDate(_date) {
    var inputFormat = DateFormat('yyyy-MM-dd');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('dd/MM/yyyy');
    return outputFormat.format(inputDate);
  }

  formatHour(_date) {
    var inputFormat = DateFormat('yyyy-MM-ddTHH:mm');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('HH:mm');
    return outputFormat.format(inputDate);
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 100,
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        title: const Text(
          "Ceuma Desk",
          style: TextStyle(fontSize: 30),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.green,
              size: 30,
            ),
            onPressed: () {
              logout();
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
          bodySolicitations()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                  createSolicitation();
                },
                child: const Text(
                  'Nova solicitação',
                  style: TextStyle(fontSize: 20),
                ),
              ))),
    );
  }

  Widget bodySolicitations() {
    return Column(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Solicitações",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                  Text(sizeList.toString(),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ],
              ),
            ),
            buttonsActions(),
            solicitationsList()
          ],
        )
      ],
    );
  }

  Widget buttonsActions() {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              width: screenWidth * 0.45,
              alignment: Alignment.center,
              child: SizedBox(
                  width: screenWidth,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:
                          closeSolicitations ? Colors.black : Colors.black26,
                      side: closeSolicitations
                          ? const BorderSide(
                              width: 1.4,
                              color: Colors.green,
                            )
                          : null,
                    ),
                    onPressed: () {
                      getSolicitationsOpen();
                    },
                    child: Text(
                      'EM ANDAMENTO',
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              closeSolicitations ? Colors.green : Colors.white),
                    ),
                  ))),
          Container(
              width: screenWidth * 0.45,
              alignment: Alignment.center,
              child: SizedBox(
                  width: screenWidth * 0.5,
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary:
                          closeSolicitations ? Colors.black26 : Colors.black,
                      side: BorderSide(
                        width: 1.4,
                        color:
                            closeSolicitations ? Colors.black26 : Colors.green,
                      ),
                    ),
                    onPressed: () {
                      getSolicitationsClose();
                    },
                    child: Text(
                      'FINALIZADO',
                      style: TextStyle(
                          fontSize: 16,
                          color:
                              closeSolicitations ? Colors.white : Colors.green),
                    ),
                  ))),
        ],
      ),
    );
  }

  Widget solicitationsList() {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        height: screenHeight * 0.5,
        width: screenWidth * 0.96,
        alignment: Alignment.center,
        child: FutureBuilder<dynamic>(
          future: solicitations,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.solicitations.isNotEmpty) {
                // setState(() {
                //   sizeList = snapshot.data!.solicitations.length;
                // });
                return ListView.builder(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    itemCount: snapshot.data!.solicitations.length,
                    itemBuilder: (BuildContext context, int index) {
                      dynamic resp = snapshot.data!.solicitations[index];
                      return Card(
                          color: const Color(0xff333533),
                          elevation: 1,
                          child: ClipPath(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  left: BorderSide(
                                      color: closeSolicitations
                                          ? const Color(0xfffca311)
                                          : Colors.green,
                                      width: 5),
                                ),
                              ),
                              child: ListTile(
                                onTap: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SolicitationDetailPage(
                                              solicitationId:
                                                  resp["solicitation_id"],
                                            )),
                                  ),
                                },
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0.0, 8.0, 0.0, 2.0),
                                      child: Text(
                                        "Setor ${resp["sector"]["name"]} - ${resp["code"]}",
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                    Text(
                                      resp["description"],
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                                subtitle: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        0.0, 10.0, 0.6, 10.0),
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Icon(Icons.timelapse_rounded,
                                              color: closeSolicitations
                                                  ? const Color(0xfffca311)
                                                  : Colors.green),
                                        ),
                                        Text(
                                          "${formatDate(resp["created_at"])} às ${formatHour(resp["created_at"])}",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 19),
                                        ),
                                      ],
                                    )),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: const Color(0xff495057),
                                      child: IconButton(
                                        icon: Icon(
                                          closeSolicitations
                                              ? Icons.hourglass_bottom
                                              : Icons.check_circle,
                                          color: closeSolicitations
                                              ? const Color(0xfffca311)
                                              : Colors.green,
                                        ),
                                        onPressed: () {},
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ));
                    });
              } else {
                return _showContainer();
              }
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ));
  }

  Widget _showContainer() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: const[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Sem solicitações',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30,
                color: Color.fromARGB(255, 103, 101, 101),
              ),
            ),
          )
        ],
      ),
    );
  }
}
