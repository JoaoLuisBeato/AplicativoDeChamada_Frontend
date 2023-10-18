import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DisciplineListState extends StatefulWidget {
  final String emailUser;

  const DisciplineListState({super.key, required this.emailUser});

  @override
  State<DisciplineListState> createState() => DisciplineList();
}

class DisciplineList extends State<DisciplineListState> {
  late double screenHeight;
  late double fontSizeAsPercentage;
  late TextStyle titleStyle;

  bool subscribeButtonVisibility = true;

  List<dynamic> dataListDisciplines = [];

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
    final response =
        await http.post(Uri.parse('http://10.0.2.2:5000/return_materias'));

    setState(() {
      dataListDisciplines = json.decode(response.body);
    });
  }

  Future<void> checkSubcribedUserOnDiscipline(String idToSendForSubscription) async {
    final response =
      await http.post(Uri.parse('http://10.0.2.2:5000/verificar_inscricao'), body: {'Email': widget.emailUser, 'ID_materia': idToSendForSubscription});

    setState(() {
      if(json.decode(response.body) == "False"){
        subscribeButtonVisibility = true;
      } else {
        subscribeButtonVisibility = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;

    TextButton popOutShowDialog(BuildContext context) {
      return TextButton(
        child: const Text('Voltar'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
    }

    Visibility subscribeShowDialog(BuildContext context, String idToSendForSubscription) {

      return Visibility(
        visible: subscribeButtonVisibility,
        child: TextButton(
        child: const Text('Inscrever-se'),
        onPressed: () async {
            final url = Uri.parse('http://10.0.2.2:5000/Materia_Aluno');

            await http.post(url, body: {
              'Nome': widget.emailUser,
              'Materia': idToSendForSubscription,
            });
            subscribeButtonVisibility = false;

          if (!mounted) return;
            Navigator.of(context).pop();
        },
      ),
      );
    }

    Future<void> showDisciplinePopUpDialog(BuildContext context, String idToSendForSubscription) async {

      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('O que deseja fazer'),
            content: const Text('Escolha uma das opções abaixo'),
            actions: <Widget>[
              popOutShowDialog(context),
              subscribeShowDialog(context, idToSendForSubscription)
            ],
          );
        },
      );
    }

    Column returnListTile(index) {
      return Column(children: [
        Container(
          width: screenHeight * 0.75,
          child: ListTile(
            title: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(dataListDisciplines[index]['nome_materias'],
                    style: style),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "ID: " + dataListDisciplines[index]['codigo_materias'],
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
                    child: Text(dataListDisciplines[index]['ementa_materias']),
                  ),
                ]),
            onTap: () async {
                checkSubcribedUserOnDiscipline(dataListDisciplines[index]['codigo_materias']);
                await Future.delayed(const Duration(seconds: 1));
                if (!mounted) return;
                showDisciplinePopUpDialog(context, dataListDisciplines[index]['codigo_materias']);
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
      itemCount: dataListDisciplines.length,
      itemBuilder: (context, index) {
        return returnListTile(index);
      },
    ));
  }
}
