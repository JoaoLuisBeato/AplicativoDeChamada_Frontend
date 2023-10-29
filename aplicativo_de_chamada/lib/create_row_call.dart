import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RowCallCreateState extends StatefulWidget {

  final String emailUser;

  const RowCallCreateState({super.key, required this.emailUser});

  @override
  State<RowCallCreateState> createState() => RowCallCreate();
}

class RowCallCreate extends State<RowCallCreateState> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  late double screenHeight;
  late double fontSizeAsPercentage;
  late TextStyle titleStyle;

  List<dynamic> disciplinesForTeacherListDynamic = [];
  List<String> disciplinesForTeacherList = [];

  int selectedIndexOnDropdownList = 0;
  String selectedDisciplineOnDropdownList = "Escolha a matéria";

  Map<String, dynamic> codeToDisplay = {};

  String codeToShow = "XXXXXX";

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    final response = await http.post(
        Uri.parse('https://chamada-backend.onrender.com/retorna_materias_professor'),
        body: {'Email': widget.emailUser});

    setState(() {
      disciplinesForTeacherListDynamic = json.decode(response.body);

      for (int i = 0; i < disciplinesForTeacherListDynamic.length; i++) {
        disciplinesForTeacherList.add(disciplinesForTeacherListDynamic[i]['nome_materia']);
      }
    });
  }

  Future<void> updateScreenWithCode() async {
   final url = Uri.parse('https://chamada-backend-sy8c.onrender.com/fazer_chamada');

    final response = await http.post(url , body: {
              'materia_escolhida': selectedDisciplineOnDropdownList.toString(),
            });

    setState(() {
      codeToDisplay = json.decode(response.body);
      codeToShow = codeToDisplay['codigo_chamada'];
    });
  }

    Future<void> confirmPopUpDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chamada criada com sucesso!'),
          content: const Text('Atualizando a tela com o código.'),  
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
          title: const Text('Erro ao criar chamada'),
          content: const Text('A matéria não foi selecionada.'),
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
    super.build(context);
    screenHeight = MediaQuery.of(context).size.height;

    TextStyle dropdownStyle =
        const TextStyle(fontWeight: FontWeight.normal, color: Colors.black);

    TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    TextStyle codeStyle = TextStyle(
        fontSize: screenHeight * 0.1,
        fontWeight: FontWeight.bold,
        color: Colors.black);

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
            });
          },
          hint: Center(
              child:
                  Text(selectedDisciplineOnDropdownList, style: dropdownStyle)),
          dropdownColor: const Color.fromARGB(255, 162, 236, 201),
        ),
      );
    }

    Text codeText(){
      return Text(codeToShow, style: codeStyle);
    }

    ButtonTheme buttonCreateCodeForRowCall() {
      return ButtonTheme(
        minWidth: screenHeight * 0.2,
        height: screenHeight * 0.1,
        child: ElevatedButton(
          onPressed: () async {

            if(selectedDisciplineOnDropdownList == "Escolha a matéria"){
              if (!mounted) return;
                createErrorPopUpDialog(context);
            } else {
              updateScreenWithCode();
              if (!mounted) return;
                confirmPopUpDialog(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: const Text(
            'Criar código da chamada',
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
                  child: Text("Gerar chamada",
                      style: titleStyle, textAlign: TextAlign.center)),
              SizedBox(height: screenHeight * 0.05),
              dropDownDisciplineButton(),
              SizedBox(height: screenHeight * 0.05),
              buttonCreateCodeForRowCall(),
              SizedBox(height: screenHeight * 0.08),
              codeText()
            ],
          ),
        ),
      ),
    );
  }
}
