import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DetailedPresenceForStudentState extends StatefulWidget {

  final String emailUser;

  const DetailedPresenceForStudentState({super.key, required this.emailUser});

  @override
  State<DetailedPresenceForStudentState> createState() => DetailedPresenceForStudent();
}

class DetailedPresenceForStudent extends State<DetailedPresenceForStudentState> {
  late double screenHeight;
  late double fontSizeAsPercentage;

    List<dynamic> dataListDisciplinesDynamic = [];
    List<String> disciplinesForStudentList = [];

    String dataFrequency = "";

    bool frequencyVisibility = false;

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

  Future<void> returnFrequency() async {
   final response = await http.post(
        Uri.parse('https://chamada-backend-sy8c.onrender.com/retornar_presenca_para_aluno_por_materia'),
        body: {'email': widget.emailUser, 'materia': selectedDisciplineOnDropdownList.toString()});

    setState(() {
      dataFrequency = json.decode(response.body);
      frequencyVisibility = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    TextStyle dropdownStyle =
      const TextStyle(fontWeight: FontWeight.normal, color: Colors.black);

    TextStyle freqStyle = TextStyle(
        fontSize: screenHeight * 0.07,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    TextStyle style = TextStyle(fontSize: screenHeight * 0.05, fontWeight: FontWeight.normal, color: Colors.black);

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
              returnFrequency();
            });
          },
          hint: Center(
              child:
                  Text(selectedDisciplineOnDropdownList, style: dropdownStyle)),
          dropdownColor: const Color.fromARGB(255, 162, 236, 201),
        ),
      );
    }

    Visibility frequencyText(){
      return Visibility(visible: frequencyVisibility,
                        child: Column(crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                            Text("Frequência:", style: style),
                            const SizedBox(height: 20),
                            Text(dataFrequency, style: freqStyle),]));
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
                  child: Text("Verificar Presença",
                      style: titleStyle, textAlign: TextAlign.center)),
              const SizedBox(height: 30),
              dropDownDisciplineButton(),
              const SizedBox(height: 20),
              frequencyText()
            ],
          ),
        ),
      ),
    );
  }
}
