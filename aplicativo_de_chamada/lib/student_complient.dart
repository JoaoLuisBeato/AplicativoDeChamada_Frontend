import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SugestionScreenCreateState extends StatefulWidget {

  final String emailUser;

  const SugestionScreenCreateState({super.key, required this.emailUser});

  @override
  State<SugestionScreenCreateState> createState() => SugestionScreenCreate();
}

class SugestionScreenCreate extends State<SugestionScreenCreateState> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  late double screenHeight;
  late double fontSizeAsPercentage;
  late TextStyle titleStyle;

  List<dynamic> dataListDisciplinesDynamic = [];
  List<String> disciplinesForStudentList = [];

  int selectedIndexOnDropdownList = 0;
  String selectedDisciplineOnDropdownList = "Escolha a matéria";

  String sugestionDescription = '';

  TextEditingController sugestionTitleTextFieldController = TextEditingController();
  TextEditingController sugestionDescriptionTextFieldController = TextEditingController();

  Map<String, dynamic> codeToDisplay = {};

  String codeToShow = "XXXXXX";

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  void clearTextFields() {
      setState(() {
        sugestionDescriptionTextFieldController.clear();
      });
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

  Future<void> createComplient() async {
   final url = Uri.parse('https://chamada-backend-sy8c.onrender.com/enviar_solicitacao');    

    await http.post(url , body: {
              'nomeAluno': widget.emailUser,
              'nomeMateria': selectedDisciplineOnDropdownList,
              'descricao': sugestionDescription
            });

    clearTextFields();
  }

    TextButton popOutShowDialog(BuildContext context){
      return TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
    }

    Future<void> confirmPopUpDialog(BuildContext context) async {

      //colocar para aparecer opção fechar chamada
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sugestão enviada com sucesso!'),
          content: const Text('Sua sugestão foi enviada'),
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
          title: const Text('Erro ao enviar sugestão'),
          content: const Text('Há campos inválidos/não preenchidos.'),
          actions: <Widget>[
              popOutShowDialog(context)
            ],
          );
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

    SizedBox sugestionDescriptionTextField() {
      return SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            sugestionDescription = text;
          },
          controller: sugestionDescriptionTextFieldController,
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: 'Escreva aqui sua sugestão',
          ),
        ),
      );
    }


     ButtonTheme buttonSendSugestion() {
      return ButtonTheme(
        minWidth: screenHeight * 0.2,
        height: screenHeight * 0.1,
        child: ElevatedButton(
          onPressed: () async {

            if(selectedDisciplineOnDropdownList == "Escolha a matéria" || 
            sugestionDescriptionTextFieldController.text.isEmpty){ 

              if (!mounted) return;
                createErrorPopUpDialog(context);        
            } else {                                
              clearTextFields();
              createComplient();
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
            'Enviar sugestão',
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
                  child: Text("Fazer sugestão",
                      style: titleStyle, textAlign: TextAlign.center)),
              SizedBox(height: screenHeight * 0.05),
              dropDownDisciplineButton(),
              SizedBox(height: screenHeight * 0.05),
              sugestionDescriptionTextField(),
              SizedBox(height: screenHeight * 0.04),
              buttonSendSugestion()
            ],
          ),
        ),
      ),
    );
  }
}
