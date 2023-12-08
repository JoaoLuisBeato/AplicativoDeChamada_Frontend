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

  String commentTextToSend = "";
  bool sendButtonVisibility = false;

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

  Future<void> sendRepositionForClass(int index) async {
    final response = await http.post(Uri.parse('https://chamada-backend-sy8c.onrender.com/enviar_solicitacao_reposicao'),
        body: {
          'motivo': commentTextToSend,
          'codigo_materia': selectedDisciplineOnDropdownList,
          'codigo_presenca': dataListClassesStudentWasAbsent[index]['CodigoPresenca'],
          'codigo_usuario': widget.emailUser,
        });
    Map<String, dynamic> existentComment = json.decode(response.body);

    if(existentComment['enviar_solicitacao_reposical'] == "existente"){
      if (!mounted) return;
        showSendCommentExistentDialog(context);
    } else {
      if (!mounted) return;
        showSendCommentSuccessDialog(context);
    }
  }

  TextButton popOutShowDialog(BuildContext context){
      return TextButton(
              child: const Text('Voltar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
    }

    Future<void> showSendCommentExistentDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro no envio do comentário'),
          content: const Text('Já foi enviado um comentário correspondente a aula.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showSendCommentErrorDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Erro no envio do comentário'),
          content: const Text('Há campos inválidos ou não preenchidos.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showSendCommentSuccessDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Comentário enviado!'),
          content: const Text('O comentário já foi enviado ao professor.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  TextButton sendCommentShowDialog(BuildContext context, int index) {

      return  TextButton(
        child: const Text('Enviar'),
        onPressed: () async {
            if(commentTextToSend != "" || selectedDisciplineOnDropdownList != "Escolha a matéria"){
              sendRepositionForClass(index);
              Navigator.of(context).pop();
            } else {
              showSendCommentErrorDialog(context);
          }
        },
      );
    }

  Future<void> showCommentPopUpDialog(BuildContext context, int index) async {
      
      SizedBox commentTextField = SizedBox(
        width: screenHeight * 0.5,
        child: TextField(
          onChanged: (text) {
            commentTextToSend = text;
          },
          maxLines: null,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: const BorderSide(width: 3),
              borderRadius: BorderRadius.circular(20.0),
            ),
            labelText: 'Justificativa da falta',
          ),
        ),
      );

      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Enviar comentário?'),
            content: commentTextField,
            actions: <Widget>[
              popOutShowDialog(context),
              sendCommentShowDialog(context, index)
            ],
          );
        },
      );
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
                onTap: () async {
                  showCommentPopUpDialog(context, index);
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
