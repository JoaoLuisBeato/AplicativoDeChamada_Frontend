import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListStudentsForEachDisciplineState extends StatefulWidget {
  final String emailUser;

  const ListStudentsForEachDisciplineState(
      {super.key, required this.emailUser});

  @override
  State<ListStudentsForEachDisciplineState> createState() => ListStudentsForEachDiscipline();
}

class ListStudentsForEachDiscipline
    extends State<ListStudentsForEachDisciplineState> {
  late double screenHeight;

  List<dynamic> disciplinesForTeacherListDynamic = [];
  List<String> disciplinesForTeacherList = [];
  List<dynamic> studentsSubscribedOnDisciplineListDynamic = [];

  bool representativeButtonVisibility = true;
  bool removeRepresentativeButtonVisibility = false;

  int selectedIndexOnDropdownList = 0;
  String selectedDisciplineOnDropdownList = "Escolha a matéria";

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    final response = await http.post(
        Uri.parse('https://chamada-backend-sy8c.onrender.com/retorna_materias_professor'),
        body: {'Email': widget.emailUser});

    setState(() {
      disciplinesForTeacherListDynamic = json.decode(response.body);

      for (int i = 0; i < disciplinesForTeacherListDynamic.length; i++) {
        disciplinesForTeacherList.add(disciplinesForTeacherListDynamic[i]['nome_materia']);
      }
    });
  }

  Future<void> fetchStudentsFromDiscipline(String disciplineForCheckStudents) async {
    final response = await http.post(
        Uri.parse('https://chamada-backend-sy8c.onrender.com/return_presenca_pela_materia'),
        body: {'materia_escolhida': disciplineForCheckStudents});

    setState(() {
      studentsSubscribedOnDisciplineListDynamic = json.decode(response.body);
    });
  }

  Future<void> showRepresentativePopUpDialog(BuildContext context, String representativeStudent, String isRepresentant, String selectedDisciplineOnDropdownList) async {
      if(isRepresentant == "True"){
        representativeButtonVisibility = false;
        removeRepresentativeButtonVisibility = true;
      } else {
        removeRepresentativeButtonVisibility = false;
      }
      
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Designar representante?'),
            content: const Text('Escolha uma das opções abaixo'),
            actions: <Widget>[
              popOutShowDialog(context),
              representativeButtonShowDialog(context, representativeStudent, selectedDisciplineOnDropdownList),
              removeRepresentativeButtonShowDialog(context, representativeStudent, selectedDisciplineOnDropdownList)
            ],
          );
        },
      );
    }

    Visibility representativeButtonShowDialog(BuildContext context, String representativeStudent, String selectedDisciplineOnDropdownList) {

      return Visibility(
        visible: representativeButtonVisibility,
        child: TextButton(
        child: const Text('Designar'),
        onPressed: () async {
            final url = Uri.parse('https://chamada-backend-sy8c.onrender.com/representante');

            await http.post(url, body: {
              'Nome': representativeStudent,
              'Materia': selectedDisciplineOnDropdownList
            });
            representativeButtonVisibility = false;
            removeRepresentativeButtonVisibility = true;

          if (!mounted) return;
            Navigator.of(context).pop();
        },
      ),
      );
    }

    Visibility removeRepresentativeButtonShowDialog(BuildContext context, String representativeStudent, String selectedDisciplineOnDropdownList) {

      return Visibility(
        visible: removeRepresentativeButtonVisibility,
        child: TextButton(
        child: const Text('Remover'),
        onPressed: () async {
            final url = Uri.parse('https://chamada-backend-sy8c.onrender.com/remover_representante');

            await http.post(url, body: {
              'Nome': representativeStudent,
              'Materia': selectedDisciplineOnDropdownList
            });
            representativeButtonVisibility = true;
            removeRepresentativeButtonVisibility = false;

          if (!mounted) return;
            Navigator.of(context).pop();
        },
      ),
      );
    }

    TextButton popOutShowDialog(BuildContext context) {
      return TextButton(
        child: const Text('Voltar'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    TextStyle dropdownStyle =
        const TextStyle(fontWeight: FontWeight.normal, color: Colors.black);

    TextStyle style = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black);

    TextStyle freqStyle = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black);

    TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    TextStyle idStyle = const TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black);

    Center dropDownDisciplineButton() {
      return Center(
        child: DropdownButton<String>(
          icon: const Icon(Icons.arrow_downward),
          style: dropdownStyle,
          items: disciplinesForTeacherList.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? selectedValueOnDropdownList) {
            setState(() {
              selectedDisciplineOnDropdownList = selectedValueOnDropdownList!;
              selectedIndexOnDropdownList = disciplinesForTeacherList.indexOf(selectedValueOnDropdownList);
              fetchStudentsFromDiscipline(selectedDisciplineOnDropdownList);
              ListStudentsForEachDisciplineState(emailUser: widget.emailUser);
            });
          },
          hint: Center(
              child:
                  Text(selectedDisciplineOnDropdownList, style: dropdownStyle)),
          dropdownColor: const Color.fromARGB(255, 162, 236, 201),
        ),
      );
    }

    Column returnListTileWithStudents(index) {

      if (studentsSubscribedOnDisciplineListDynamic[index][3] == "True"){
        style = const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.red);
      } else {
        style = const TextStyle(fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black);
      }

      return Column(children: [
        Container(
          width: screenHeight * 0.75,
          child: ListTile(
            title: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  studentsSubscribedOnDisciplineListDynamic[index][0], style: style,    //vai verificar se é representante, novo style
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "RA: ${studentsSubscribedOnDisciplineListDynamic[index][1]}",
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
                    child: Text("Frequência: ${studentsSubscribedOnDisciplineListDynamic[index][2]}", style: freqStyle,),
                  ),
                ]),

                onTap: () async {
                  showRepresentativePopUpDialog(context, studentsSubscribedOnDisciplineListDynamic[index][0], studentsSubscribedOnDisciplineListDynamic[index][3], selectedDisciplineOnDropdownList);
            },
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
              dropDownDisciplineButton(),
              SizedBox(height: screenHeight * 0.05),
              Container(
                width: 1200,
                height: screenHeight * 0.6,
                child: ListView.builder(
                  itemCount: studentsSubscribedOnDisciplineListDynamic.length,
                  itemBuilder: (context, index) {
                    return returnListTileWithStudents(index);
                  },
                )
              )
            ],
          ),
        )),
      ),
    );
  }
}
