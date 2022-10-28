import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:help_desck_app/api/solicitations.api.dart';
import 'package:help_desck_app/models/solicitation.model.dart';
import 'package:help_desck_app/pages/solicitations.page.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SolicitationDetailPage extends StatefulWidget {
  final int solicitationId;

  const SolicitationDetailPage({Key? key, required this.solicitationId})
      : super(key: key);

  @override
  State<SolicitationDetailPage> createState() => _SolicitationDetailPageState();
}

class _SolicitationDetailPageState extends State<SolicitationDetailPage> {
  late Future<SolicitationModel> solicitation;
  late bool loading = true;
  late String userType = '';

  bool loadingSubmit = false;
  late bool loadingClose = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController solutionDescriptionController = TextEditingController();

  getSolicitation() async {
    setState(() {
      solicitation = SolicitationApi.getSolicitationById(widget.solicitationId);
      loading = false;
    });
  }

  void getUserType() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String? userTypeLocal = _prefs.getString('user_type');
    userType = userTypeLocal!;
    if (kDebugMode) {
      print(userType);
    }
  }

  createNewSolution() async {
    setState(() {
      loadingSubmit = true;
    });

    SolutionCreateModel solution = SolutionCreateModel();
    SolicitationModel solicitationModel = SolicitationModel();
    solution.description = solutionDescriptionController.text;
    solicitationModel.solicitation_id = widget.solicitationId;
    solution.solicitation = solicitationModel;

    var response = await SolicitationApi.createSolution(solution);
    if (response.statusCode == 201) {
      setState(() {
        solutionDescriptionController.text = "";
        loadingSubmit = false;
        Fluttertoast.showToast(
          msg: 'Solução adicionada com sucesso!',
          toastLength: Toast.LENGTH_SHORT,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      });
      getSolicitation();
    } else {
      setState(() {
        solutionDescriptionController.text = "";
        loadingSubmit = false;
      });
      Fluttertoast.showToast(
        msg: 'Não foi possível adicionar a solução',
        toastLength: Toast.LENGTH_SHORT,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  resolveSolicitation() async {
    setState(() {
      loadingClose = true;
    });

    var response =
        await SolicitationApi.resolveSolicitation(widget.solicitationId);

    if (response.statusCode == 200) {
      dialogMessage(true);
      setState(() {
        loadingClose = false;
        getSolicitation();
      });
    } else {
      setState(() {
        loadingClose = false;
      });
      dialogMessage(false);
    }
  }

  void dialogMessage(bool success) async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: contentBox(context, success),
          );
        });
  }

  void dialogCreateSolution() async {
    return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: contentBoxCreateSolution(context),
          );
        });
  }

  contentBoxCreateSolution(context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.loose,
      children: <Widget>[
        Container(
          width: screenWidth,
          height: 320,
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
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text(
                "Nova solução",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 15,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  maxLines: 5,
                  controller: solutionDescriptionController,
                  style: const TextStyle(fontSize: 20, color: Colors.white),
                  decoration: InputDecoration(
                    hintStyle:
                        const TextStyle(fontSize: 18.0, color: Colors.white),
                    fillColor: const Color.fromARGB(80, 0, 0, 0),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.transparent, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    errorStyle:
                        const TextStyle(color: Colors.white, fontSize: 18),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: const BorderSide(
                          color: Colors.transparent, width: 0.0),
                    ),
                    hintText: 'Você deve informar uma solução para o problema',
                  ),
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Informe seu nome';
                    } else if (value.length < 6) {
                      return 'Deve ter mais de 6 caracteres';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: screenWidth * 0.3,
                    height: 45,
                    padding: const EdgeInsets.all(2),
                    child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).pop();
                            createNewSolution();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green[900],
                        ),
                        child: const SizedBox(
                          child: Text(
                            "Salvar",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        )),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2),
                    width: screenWidth * 0.3,
                    height: 45,
                    child: TextButton(
                        onPressed: () {
                          loadingSubmit ? null : Navigator.of(context).pop();
                          setState(() {
                            solutionDescriptionController.text = "";
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red[900],
                        ),
                        child: const Text(
                          "Canelar",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        )),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  contentBox(context, bool success) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.loose,
      children: <Widget>[
        Container(
          width: screenWidth,
          height: 250,
          padding: const EdgeInsets.only(
              left: 20, top: 45 + 20, right: 20, bottom: 20),
          margin: const EdgeInsets.only(top: 45),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFF22223b),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                success ? 'Sucesso!' : 'Atenção',
                style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                success
                    ? "Solicitação finalizada com sucesso!"
                    : 'Não foi possível encerrar esta solicitação',
                style: const TextStyle(fontSize: 20, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 22,
              ),
              Container(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 40,
                    width: screenWidth * 0.5,
                    child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.green,
                          shadowColor: Colors.green[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28),
                          ),
                          elevation: 5,
                          textStyle: const TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.w600),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          "Fechar",
                          style: TextStyle(fontSize: 18),
                        )),
                  ))
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
                child: success
                    ? Image.asset("assets/success.png")
                    : Image.asset("assets/close.png")),
          ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    getUserType();
    getSolicitation();
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: const Color.fromARGB(200, 0, 0, 0),
        toolbarHeight: 100,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
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
        title: const Text(
          "Solicitação",
          style: TextStyle(fontSize: 24),
        ),
      ),
      body: Stack(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
            decoration: const BoxDecoration(color: Colors.black87),
          ),
          detailBody()
        ],
      ),
    );
  }

  Widget header(resp) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(10),
        width: screenWidth,
        height: 55,
        decoration: const BoxDecoration(color: Colors.black26),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              child: Icon(
                resp.status == 'OPEN'
                    ? Icons.hourglass_bottom
                    : Icons.check_circle,
                color: resp.status == 'OPEN'
                    ? const Color(0xfffca311)
                    : Colors.green,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 0.0, 5.0, 0.0),
              child: Text(
                resp.status == 'OPEN' ? 'EM ANDAMENTO' : 'FINALIZADO',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: resp.status == 'OPEN'
                        ? const Color(0xfffca311)
                        : Colors.green),
              ),
            ),
          ],
        ));
  }

  Widget detailBody() {
    return SingleChildScrollView(
      child: FutureBuilder<SolicitationModel>(
          future: solicitation,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              SolicitationModel? resp = snapshot.data;
              return Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    header(resp),
                    sectorContainer(resp!),
                    userContainer(resp),
                    descriptionContainer(resp),
                    solutionsContainer(resp),
                    solutionsOptionsContainer(resp),
                    createSolution(resp),
                    closeSolicitations(resp),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return SizedBox(
                  height: MediaQuery.of(context).size.height / 1.3,
                  child: const Center(
                    child: Text(
                      "Não foi possível retornar dos dados",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ));
            }
            return SizedBox(
              height: MediaQuery.of(context).size.height / 1.3,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }),
    );
  }

  Widget sectorContainer(SolicitationModel resp) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.9,
      margin: const EdgeInsets.only(top: 20.0),
      child: Card(
        color: const Color(0xff333533),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.person_search_sharp,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "Setor",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          subtitle: Padding(
            padding: const EdgeInsets.all(10),
            child: Text(
              resp.sector!.name,
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Widget userContainer(SolicitationModel resp) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.9,
      margin: const EdgeInsets.only(top: 20.0),
      child: Card(
        color: const Color(0xff333533),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.person_search_sharp,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "Usuário que solicitou",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          subtitle: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resp.user_requested!.name!,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: Text(
                      "Registrado em ${formatDate(resp.created_at)} às ${formatHour(resp.created_at)}",
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget descriptionContainer(SolicitationModel resp) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.9,
      margin: const EdgeInsets.only(top: 20.0),
      child: Card(
        color: const Color(0xff333533),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.book_outlined,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "Descrição do problema",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          subtitle: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resp.description!,
                    style: const TextStyle(fontSize: 20, color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: Text(
                      "Registrado em ${formatDate(resp.created_at)} às ${formatHour(resp.created_at)}",
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget solutionsContainer(SolicitationModel resp) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.9,
      margin: const EdgeInsets.only(top: 20.0),
      child: Card(
        color: const Color(0xff333533),
        child: ListTile(
          title: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Icon(
                    Icons.computer,
                    color: Colors.green,
                  ),
                ),
                Text(
                  "Soluções",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          subtitle: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  resp.closed_at != null
                      ? Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                          child: Text(
                            "Encerrado em ${formatDate(resp.closed_at)} às ${formatHour(resp.closed_at)}",
                            style: const TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      : const SizedBox(
                          width: 0.0,
                          height: 0.0,
                        ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    child: Text(
                      resp.solutions!.isNotEmpty
                          ? "${resp.solutions!.length} soluções para este problema"
                          : "Este problema ainda não possui soluções",
                      style: const TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  Widget solutionsOptionsContainer(SolicitationModel resp) {
    double screenWidth = MediaQuery.of(context).size.width;
    return resp.solutions!.isNotEmpty
        ? Container(
            width: screenWidth * 0.87,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(
              color: Color(0xff333533),
            ),
            child: loadingSubmit
                ? const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: SizedBox(
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                      height: 30.0,
                      width: 20.0,
                    ),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: resp.solutions!.length,
                    itemBuilder: (BuildContext context, int index) {
                      dynamic solution = resp.solutions![index];
                      return ListTile(
                        title: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${index + 1} - ${solution["description"]}",
                                  style: const TextStyle(
                                      fontSize: 15, color: Colors.white),
                                ),
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 10.0, 0.0, 0.0),
                                  child: Text(
                                    "Registrado em ${formatDate(resp.created_at)} às ${formatHour(resp.created_at)}",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text("Usuário: ${solution["user"]["name"]}",
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold)),
                              ],
                            )),
                      );
                    }))
        : const SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }

  Widget closeSolicitations(SolicitationModel resp) {
    double screenWidth = MediaQuery.of(context).size.width;
    return resp.status == 'OPEN'
        ? Container(
            width: screenWidth * 0.9,
            padding: const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 0.0),
            alignment: Alignment.center,
            child: SizedBox(
                width: screenWidth,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightGreen[900],
                  ),
                  onPressed: () {
                    resolveSolicitation();
                  },
                  child: loadingClose
                      ? const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Encerrar solicitação',
                          style: TextStyle(fontSize: 20),
                        ),
                )))
        : const SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }

  Widget createSolution(SolicitationModel resp) {
    double screenWidth = MediaQuery.of(context).size.width;
    return (resp.status == 'OPEN' && userType == 'ADMIN')
        ? Container(
            width: screenWidth * 0.9,
            padding: const EdgeInsets.fromLTRB(4.0, 10.0, 4.0, 0.0),
            alignment: Alignment.center,
            child: SizedBox(
                width: screenWidth,
                height: 60,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue[900],
                  ),
                  onPressed: () {
                    dialogCreateSolution();
                  },
                  child: const Text(
                    'Sugerir uma solução',
                    style: TextStyle(fontSize: 20),
                  ),
                )))
        : const SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }
}
