import 'package:flutter/material.dart';

Widget sectorField(sectorController, context, sectorFinal, data, loading) {
  return Padding(
    padding: const EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
    child: TextFormField(
      readOnly: true,
      controller: sectorController,
      onTap: () => {
          if(loading){
            null,
          }else{
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  double screenWidth = MediaQuery.of(context).size.width;
                  return Dialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      child: selectSector(context, sectorFinal, data, sectorController)
                  );
                }),
          }
      },
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
        suffixIcon: loading ? Transform.scale(
          scale: 0.5,
          child: const CircularProgressIndicator(),
        ) : null,
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

Widget selectSector(context, sectorFinal, data, sectorController) {
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
            Expanded(child: ListView.builder(
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
                  groupValue: sectorFinal,
                  onChanged: (dynamic value) {
                    sectorFinal.value = value;
                    sectorController.text = value["name"];
                    Navigator.pop(context);
                  },
                );
              },
            ),)
          ],
        ),
      )
    ],
  );
}