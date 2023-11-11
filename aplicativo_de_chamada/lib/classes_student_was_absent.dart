import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClassesStudentWasAbsentListState extends StatefulWidget {
  final String emailUser;

  const ClassesStudentWasAbsentListState({super.key, required this.emailUser});

  @override
  State<ClassesStudentWasAbsentListState> createState() =>
      ClassesStudentWasAbsentList();
}

class ClassesStudentWasAbsentList extends State<ClassesStudentWasAbsentListState> {
  late double screenHeight;
  late double fontSizeAsPercentage;
  late TextStyle titleStyle;

  List<dynamic> dataListDisciplinesDynamic = [];
  List<String> disciplinesForStudentList = [];

  List<dynamic> dataListClassesStudentWasAbsent = [];

  int selectedIndexOnDropdownList = 0;
  String selectedDisciplineOnDropdownList = "Escolha a matéria";

  TextStyle style = const TextStyle(
      fontSize: 30, fontWeight: FontWeight.normal, color: Colors.black);

  TextStyle idStyle = const TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black);

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    final response = await http.post(
        Uri.parse(
            'https://chamada-backend-sy8c.onrender.com/return_materias_inscritas_do_aluno'),
        body: {'email': widget.emailUser});

    setState(() {
      dataListDisciplinesDynamic = json.decode(response.body);

      for (int i = 0; i < dataListDisciplinesDynamic.length; i++) {
        disciplinesForStudentList
            .add(dataListDisciplinesDynamic[i]['nome_materia']);
      }
    });
  }

  Future<void> fetchClassesFromDiscipline() async {
    final response = await http.post(
        Uri.parse(
            'https://chamada-backend-sy8c.onrender.com/returnAulasFaltantes'),
        body: {
          'email': widget.emailUser,
          'materia': selectedDisciplineOnDropdownList
        });

    setState(() {
      dataListClassesStudentWasAbsent = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    TextStyle dropdownStyle =
        const TextStyle(fontWeight: FontWeight.normal, color: Colors.black);

    TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black);

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
              selectedIndexOnDropdownList = disciplinesForStudentList
                  .indexOf(selectedValueOnDropdownList);
              fetchClassesFromDiscipline();
            });
          },
          hint: Center(
              child:
                  Text(selectedDisciplineOnDropdownList, style: dropdownStyle)),
          dropdownColor: const Color.fromARGB(255, 162, 236, 201),
        ),
      );
    }

    Column returnListTileWithClasses(index) {

      return Column(children: [
        Container(
          width: screenHeight * 0.75,
          child: ListTile(
            title: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  dataListClassesStudentWasAbsent[index]['Titulo'], style: style,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "Código: ${dataListClassesStudentWasAbsent[index]['CodigoPresenca']}",
                      style: idStyle, 
                    ),
                  ),
                ),
              ),
            ]),
            subtitle: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Text(dataListClassesStudentWasAbsent[index]['Descricao']),
                  ),
                ]),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 50),
          child: Divider(
            color: Color.fromARGB(255, 162, 236, 201),
            height: 10.0,
          ),
        ),
      ]);
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
                  child: Text("Aulas ausente",
                      style: titleStyle, textAlign: TextAlign.center)),
              const SizedBox(height: 30),
              dropDownDisciplineButton(),
              const SizedBox(height: 20),
              Container(
                      width: 1200,
                      height: screenHeight * 0.6,
                      child: ListView.builder(
                        itemCount:
                            dataListClassesStudentWasAbsent.length,
                        itemBuilder: (context, index) {
                          return returnListTileWithClasses(index);
                        },
                      ))
            ],
          ),
        ),
      ),
    );
  }
}
