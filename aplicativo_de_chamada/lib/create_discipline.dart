import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisciplineCreateState extends StatefulWidget {
  const DisciplineCreateState({super.key});

  @override
  State<DisciplineCreateState> createState() => DisciplineCreate();
}

class DisciplineCreate extends State<DisciplineCreateState> {
  late double screenHeight;
  late double fontSizeAsPercentage;
  late TextStyle titleStyle;

  
    String disciplineTitle = '';
    String disciplineDescription = '';

    TextEditingController disciplineTitleTextFieldController = TextEditingController();
    TextEditingController disciplineDescriptionTextFieldController = TextEditingController();

    String errorTextValDiscipline = '';
    String errorTextValDisciplineDescription = '';

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.07,
        fontWeight: FontWeight.bold,
        color: Colors.black);
    
    SizedBox disciplineTitleTextField() {
      return SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            disciplineTitle = text;
            setState(() {
              //colocar verificaçao de campo vazio
            });
          },
          controller: disciplineTitleTextFieldController,
          decoration: InputDecoration(
            errorText: errorTextValDiscipline.isEmpty ? null : errorTextValDiscipline,
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: 'Nome da matéria',
          ),
        ),
      );
    }

    SizedBox disciplineDescriptionTextField() {
      return SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            disciplineDescription = text;
            setState(() {
              //colocar verificaçao de campo vazio
            });
          },
          controller: disciplineDescriptionTextFieldController,
          maxLines: null,
          decoration: InputDecoration(
            errorText: errorTextValDisciplineDescription.isEmpty ? null : errorTextValDisciplineDescription,
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: 'Ementa da matéria',
          ),
        ),
      );
    }

    ButtonTheme buttonCreateDiscipline() {
      return ButtonTheme(
        minWidth: screenHeight * 0.2,
        height: screenHeight * 0.1,
        child: ElevatedButton(
          onPressed: () async {
            final url = Uri.parse('http://10.0.2.2:5000/Registrar_materia');

            final response = await http.post(url, body: {
              'Nome_materia': disciplineTitle,
              'Nome_professor': disciplineTitle, // trocar dps ou por email ou fazer request de nome
              'Ementa': disciplineDescription
            });

            //criar caixa de dialogo se resposta for 200 ou outra
            //limpar campos
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.greenAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
          ),
          child: const Text(
            'Criar matéria',
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
                  child: Text("Criar matéria",
                      style: titleStyle, textAlign: TextAlign.center)),
              const SizedBox(height: 30),
              disciplineTitleTextField(),
              const SizedBox(height: 20),
              disciplineDescriptionTextField(),
              const SizedBox(height: 20),
              buttonCreateDiscipline()
            ],
          ),
        ),
      ),
    );
  }
}
