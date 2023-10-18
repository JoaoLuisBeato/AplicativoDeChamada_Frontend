import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListStudentsForEachDisciplineState extends StatefulWidget {
  final String emailUser;

  const ListStudentsForEachDisciplineState({super.key, required this.emailUser});

  @override
  State<ListStudentsForEachDisciplineState> createState() => ListStudentsForEachDiscipline();
}

class ListStudentsForEachDiscipline extends State<ListStudentsForEachDisciplineState> {
  late double screenHeight;

  List<dynamic> disciplinesForTeacherListDynamic = [];
  List<String> disciplinesForTeacherList = [];

  int selectedIndexOnDropdownList = 0;
  String selectedDisciplineOnDropdownList = "Escolha a matéria";

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    final response =
        await http.post(Uri.parse('http://10.0.2.2:5000/retorna_materias_professor'), body: {'Email': widget.emailUser});

    setState(() {
      disciplinesForTeacherListDynamic = json.decode(response.body);

      for(int i = 0; i < disciplinesForTeacherListDynamic.length; i++){
        disciplinesForTeacherList.add(disciplinesForTeacherListDynamic[i]['nome_materia']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

      TextStyle dropdownStyle = const TextStyle(
        fontWeight: FontWeight.normal,
        color: Colors.black
      );

      TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    Center dropDownDisciplineButton(){
      return Center(
        child: DropdownButton<String>(
          icon: const Icon(Icons.arrow_downward),
          style: dropdownStyle,
          items: disciplinesForTeacherList.map((String value){
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
              );
          }).toList(),
          onChanged: (String? selectedValueOnDropdownList){
            setState(() {
              selectedDisciplineOnDropdownList = selectedValueOnDropdownList!;
              selectedIndexOnDropdownList = disciplinesForTeacherList.indexOf(selectedValueOnDropdownList);
              //entrar rota de listagem dos alunos apos selecionar materia
            });
          },
          hint: Center(child: Text(selectedDisciplineOnDropdownList, style: dropdownStyle)),
          dropdownColor: const Color.fromARGB(255, 162, 236, 201),
      ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Text("Alunos da matéria",
                      style: titleStyle, textAlign: TextAlign.center)),
              SizedBox(height: screenHeight * 0.08),
              dropDownDisciplineButton()
            ],
          ),
          ) 
      ),
      ),
    );
  }
}