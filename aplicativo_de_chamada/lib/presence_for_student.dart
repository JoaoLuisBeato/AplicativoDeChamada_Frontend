import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PresenceForStudentCheckState extends StatefulWidget {

  final String emailUser;

  const PresenceForStudentCheckState({super.key, required this.emailUser});

  @override
  State<PresenceForStudentCheckState> createState() => CodeInsertCheck();
}

class CodeInsertCheck extends State<PresenceForStudentCheckState> {
  late double screenHeight;
  late double fontSizeAsPercentage;
  late TextStyle titleStyle;

    String codeInserted = '';

    TextEditingController codeTextFieldController = TextEditingController();

    String errorTextValDiscipline = '';

    List<dynamic> dataListDisciplinesDynamic = [];
    List<String> disciplinesForStudentList = [];

    int selectedIndexOnDropdownList = 0;
    String selectedDisciplineOnDropdownList = "Escolha a matéria";

    @override
    void initState() {
      super.initState();
      fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    final response = await http.post(
        Uri.parse('https://chamada-backend-sy8c.onrender.com/return_materias_inscritas_do_aluno'),
        body: {'email': widget.emailUser});

    setState(() {
      dataListDisciplinesDynamic = json.decode(response.body);

      for (int i = 0; i < dataListDisciplinesDynamic.length; i++) {
        disciplinesForStudentList.add(dataListDisciplinesDynamic[i]['nome_materia']);
      }
    });
  }

    Future<void> confirmPopUpDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sua presença foi contabilizada!'),
          content: const Text('Sua frequência na matéria foi atualizada.'),
          actions: <Widget>[
              popOutShowDialog(context)
            ],
          );
        },
      );
    }

    Future<void> createErrorPopUpDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro ao contabilizar presença'),
          content: const Text('O campo matéria ou o código não são válidos'),
          actions: <Widget>[
              popOutShowDialog(context)
            ],
          );
        },
      );
    }

    TextButton popOutShowDialog(BuildContext context){
      return TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
    }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.07,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    TextStyle dropdownStyle =
        const TextStyle(fontWeight: FontWeight.normal, color: Colors.black);

    void clearTextFields() {
      setState(() {
        codeTextFieldController.clear();
      });
    }

    Center dropDownDisciplineButton() {
      return Center(
        child: DropdownButton<String>(
          icon: const Icon(Icons.arrow_downward),
          style: dropdownStyle,
          items: disciplinesForStudentList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? selectedValueOnDropdownList) {
            setState(() {
              selectedDisciplineOnDropdownList = selectedValueOnDropdownList!;
              selectedIndexOnDropdownList = disciplinesForStudentList.indexOf(selectedValueOnDropdownList);
            });
          },
          hint: Center(
              child:
                  Text(selectedDisciplineOnDropdownList, style: dropdownStyle)),
          dropdownColor: const Color.fromARGB(255, 162, 236, 201),
        ),
      );
    }
    
    SizedBox codeToInsertTextField() {
      return SizedBox(
        width: screenHeight * 0.5,
        height: screenHeight * 0.2,
        child: TextField(
          onChanged: (text) {
            codeInserted = text;
          },
          controller: codeTextFieldController,
          textAlign: TextAlign.center,
          decoration: InputDecoration(
            errorText: errorTextValDiscipline.isEmpty ? null : errorTextValDiscipline,
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            label:const Center(
              child: Text("Código da presença"),
          ),
          ),
          style: TextStyle(fontSize: screenHeight * 0.07),
        ),
      );
    }

    ButtonTheme buttonGetPresence() {
      return ButtonTheme(
        minWidth: screenHeight * 0.2,
        height: screenHeight * 0.1,
        child: ElevatedButton(
          onPressed: () async {

            if(codeTextFieldController.text.isEmpty || selectedDisciplineOnDropdownList == "Escolha a matéria"){
                createErrorPopUpDialog(context);
            } else {
              final url = Uri.parse('https://chamada-backend-sy8c.onrender.com/verificar_codigo_inserido_pelo_aluno');

              final response = await http.post(url, body: {
                'email': widget.emailUser,
                'code': codeInserted,
                'materia': selectedDisciplineOnDropdownList
              });

              final jsonResponse = json.decode(response.body);
              String confirmPresence = jsonResponse['presenca'];

              if (!mounted) return;
                if(confirmPresence == "OK"){
                  confirmPopUpDialog(context);
                } else {
                  createErrorPopUpDialog(context);
                }
              clearTextFields();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: const Text(
            'Contar presença',
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Text("Pegar presença",
                      style: titleStyle, textAlign: TextAlign.center)),
              const SizedBox(height: 30),
              dropDownDisciplineButton(),
              const SizedBox(height: 20),
              codeToInsertTextField(),
              const SizedBox(height: 20),
              buttonGetPresence()//trocar para botao que envia o código
            ],
          ),
        ),
      ),
    );
  }
}
