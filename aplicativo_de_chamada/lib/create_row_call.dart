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

  String givenClassTitle = '';
  String givenClassDescription = '';

  TextEditingController givenClassTitleTextFieldController = TextEditingController();
  TextEditingController givenClassDescriptionTextFieldController = TextEditingController();

  Map<String, dynamic> codeToDisplay = {};

  String codeToShow = "XXXXXX";

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  void clearTextFields() {
      setState(() {
        givenClassDescriptionTextFieldController.clear();
        givenClassTitleTextFieldController.clear();
      });
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

  Future<void> updateScreenWithCode() async {
   final url = Uri.parse('https://chamada-backend-sy8c.onrender.com/fazer_chamada');   

    final response = await http.post(url , body: {
              'materia_escolhida': selectedDisciplineOnDropdownList.toString(),
              'titulo': givenClassTitle.toString(),
              'descricao': givenClassDescription.toString()
            });

    setState(() {
      codeToDisplay = json.decode(response.body);
      codeToShow = codeToDisplay['codigo_chamada'];
    });
  }

  Future<void> colecttiveRowCall() async {
   final url = Uri.parse('https://chamada-backend-sy8c.onrender.com/presenca_coletiva');    

    final response = await http.post(url , body: {
              'materia': selectedDisciplineOnDropdownList.toString(),
              'titulo': givenClassTitle.toString(),
              'descricao': givenClassDescription.toString()
            });

    clearTextFields();
  }

    Future<void> confirmPopUpDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Chamada criada com sucesso!'),
          content: const Text('A presença foi disponibilizada.'),
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
          content: const Text('Há campos inválidos/não preenchidos.'),
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

    SizedBox givenClassTitleTextField() {
      return SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            givenClassTitle = text;  
          },
          controller: givenClassTitleTextFieldController,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: 'Título da aula dada',
          ),
        ),
      );
    }

    SizedBox givenClassDescriptionTextField() {
      return SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            givenClassDescription = text;
          },
          controller: givenClassDescriptionTextFieldController,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: 'Descrição do conteúdo dado',
          ),
        ),
      );
    }

    ButtonTheme buttonCreateCodeForRowCall() {
      return ButtonTheme(
        minWidth: screenHeight * 0.2,
        height: screenHeight * 0.1,
        child: ElevatedButton(
          onPressed: () async {

            if(selectedDisciplineOnDropdownList == "Escolha a matéria" || 
            givenClassTitleTextFieldController.text.isEmpty || 
            givenClassDescriptionTextFieldController.text.isEmpty){ 

              if (!mounted) return;
                createErrorPopUpDialog(context);        
            } else {
              updateScreenWithCode();                                   
              clearTextFields();
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

    ButtonTheme buttonCollectiveRowCall() {
      return ButtonTheme(
        minWidth: screenHeight * 0.2,
        height: screenHeight * 0.1,
        child: ElevatedButton(
          onPressed: () async {//colocar condiçioes de campos de texto vazio + janela de confirmação + limpa de textos

          if(selectedDisciplineOnDropdownList == "Escolha a matéria" || 
            givenClassTitleTextFieldController.text.isEmpty || 
            givenClassDescriptionTextFieldController.text.isEmpty){ 
              
              if (!mounted) return;
                createErrorPopUpDialog(context);        
            } else {
              colecttiveRowCall();                                   
              clearTextFields();
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
            'Gerar presença coletiva',
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
              givenClassTitleTextField(),
              SizedBox(height: screenHeight * 0.04),
              givenClassDescriptionTextField(),
              SizedBox(height: screenHeight * 0.04),
              buttonCreateCodeForRowCall(),
              SizedBox(height: screenHeight * 0.04),
              buttonCollectiveRowCall(),
              SizedBox(height: screenHeight * 0.04),
              codeText()
            ],
          ),
        ),
      ),
    );
  }
}
