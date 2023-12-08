import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentsForTeacherListState extends StatefulWidget {
  final String emailUser;

  const CommentsForTeacherListState({super.key, required this.emailUser});

  @override
  State<CommentsForTeacherListState> createState() => CommentsForTeacherList();
}

class CommentsForTeacherList extends State<CommentsForTeacherListState> {
  late double screenHeight;
  late double fontSizeAsPercentage;
  late TextStyle titleStyle;

  bool subscribeButtonVisibility = true;

  List<dynamic> dataListCommentsForTeachers = [];

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
            'https://chamada-backend-sy8c.onrender.com/ler_solicitacoes_reposicao'),
        body: {
          'email_prof': widget.emailUser,
        });

    setState(() {
      dataListCommentsForTeachers = json.decode(response.body);
    });
  }

  Future<void> responseForSolicitation(String answer, int index) async {
   
      await http.post(Uri.parse(
            'https://chamada-backend-sy8c.onrender.com/verificar_solicitacao_reposicao'),
        body: {
          'resposta': answer,
          'codigo_usuario': dataListCommentsForTeachers[index]['codigo_usuario'],
          'codigo_materia': dataListCommentsForTeachers[index]['codigo_materia'].toString(),
          'codigo_presenca': dataListCommentsForTeachers[index]['codigo_presenca'].toString()
        });

        if(!mounted) return;
         showUpdatedStatusForSolicitationDialog(context);
  }

  TextButton popOutShowDialog(BuildContext context){
      return TextButton(
              child: const Text('Voltar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            );
    }

    TextButton popOutYesDialog(BuildContext context, int index){
      return TextButton(
              child: const Text('Sim'),
              onPressed: () {
                Navigator.of(context).pop();
                responseForSolicitation("Sim", index);
              },
            );
    }

    TextButton popOutNoDialog(BuildContext context, int index){
      return TextButton(
              child: const Text('Não'),
              onPressed: () {
                Navigator.of(context).pop();
                responseForSolicitation("Nao", index);
              },
            );
    }

    Future<void> showCommentDialog(BuildContext context, int index) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Dar presença?'),
          content: Text("Justificativa do aluno: ${dataListCommentsForTeachers[index]['motivo']}"),
          actions: <Widget>[
            popOutShowDialog(context),
            popOutYesDialog(context, index),
            popOutNoDialog(context, index)
          ],
        );
      },
    );
  }

  Future<void> showUpdatedStatusForSolicitationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resposta atualizada!'),
          content: const Text("O Status e a presença foram atualizados conforme a resposta"),
          actions: <Widget>[
            popOutShowDialog(context),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    Column returnListTile(index) {
      return Column(children: [
        Container(
          width: screenHeight * 0.75,
          child: ListTile(
            title: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(dataListCommentsForTeachers[index]['codigo_materia'].toString(),
                    style: style),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "Código: ${dataListCommentsForTeachers[index]['codigo_presenca']}",
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
                    child: Text("Status: ${dataListCommentsForTeachers[index]['status']}",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Text("Aluno: ${dataListCommentsForTeachers[index]['codigo_usuario']}",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Text("Motivo: ${dataListCommentsForTeachers[index]['motivo']}"),
                  ),
                ]),
                onTap: () {
                  showCommentDialog(context, index);
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
        body: ListView.builder(
          itemCount: dataListCommentsForTeachers.length,
          itemBuilder: (context, index) {
        return returnListTile(index);
      },
    ));
  }
}
