import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DisciplineCreateState extends StatefulWidget {

  final String emailUser;

  const DisciplineCreateState({super.key, required this.emailUser});

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

    Future<void> confirmPopUpDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Matéria criada com sucesso!'),
          content: const Text('A matéria já foi listada para os alunos'),
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
          title: const Text('Erro ao criar matéria'),
          content: const Text('Campos não foram preenchidos corretamente'),
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

    void clearTextFields() {
      setState(() {
        disciplineDescriptionTextFieldController.clear();
        disciplineTitleTextFieldController.clear();
      });
    }
    
    SizedBox disciplineTitleTextField() {
      return SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            disciplineTitle = text;
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

            if(disciplineTitleTextFieldController.text.isEmpty || disciplineDescriptionTextFieldController.text.isEmpty){
              if (!mounted) return;
                createErrorPopUpDialog(context);
            } else {
              final url = Uri.parse('http://https://chamada-backend-develop.onrender.com/Registrar_materia');

              await http.post(url, body: {
                'Nome_materia': disciplineTitle,
                'Nome_professor': widget.emailUser,
                'Ementa': disciplineDescription
              });

              if (!mounted) return;
                confirmPopUpDialog(context);
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
