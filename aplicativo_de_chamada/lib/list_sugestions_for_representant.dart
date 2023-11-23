import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SugestionListForRepresentantState extends StatefulWidget {
  final String emailUser;

  const SugestionListForRepresentantState(
      {super.key, required this.emailUser});

  @override
  State<SugestionListForRepresentantState> createState() => SugestionListForRepresentant();
}

class SugestionListForRepresentant
    extends State<SugestionListForRepresentantState> {
  late double screenHeight;

  List<dynamic> sugestionListDynamic = [];

  int selectedIndexOnDropdownList = 0;

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    final response = await http.post(
        Uri.parse('https://chamada-backend-sy8c.onrender.com/ler_solicitacao'),
        body: {'emailAluno': widget.emailUser});

    setState(() {
      sugestionListDynamic = json.decode(response.body);
    });
  }

  Future<void> confirmPopUpDialog(BuildContext context, int ID) async {

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('O que deseja fazer'),
          content: const Text('Você pode remover essa sugestão'),
          actions: <Widget>[
              removeSugestionButtonShowDialog(context, ID),
              popOutShowDialog(context)
            ],
          );
        },
      );
    }

    Future<void> removedPopUpDialog() async {

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sugestão removida'),
          content: const Text('A sugestão selecionada foi apagada'),
          actions: <Widget>[
              popOutShowDialog(context)
            ],
          );
        },
      );
    }

    TextButton removeSugestionButtonShowDialog(BuildContext context, int ID) {

        return TextButton(
        child: const Text('Remover'),
        onPressed: () async {
            final url = Uri.parse('https://chamada-backend-sy8c.onrender.com/remover_solicitacao');

            await http.post(url, body: {
              'ID': ID.toString()
            });

          if (!mounted) return;
            Navigator.of(context).pop();
            removedPopUpDialog();
        },
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

    TextStyle style = const TextStyle(
      fontSize: 20, fontWeight: FontWeight.normal, color: Colors.black);

    TextStyle freqStyle = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.normal, color: Colors.black);

    TextStyle nameStyle = const TextStyle(
      fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black);

    TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    TextStyle idStyle = const TextStyle(
      fontSize: 12, fontWeight: FontWeight.normal, color: Colors.black);

    Column returnListTileWithStudents(index) {
      
      return Column(children: [
        Container(
          width: screenHeight * 0.75,
          child: ListTile(
            title: Row(children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "${sugestionListDynamic[index][3]}", style: style,    //vai verificar se é representante, novo style
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "ID: ${sugestionListDynamic[index][0]}",
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
                    child: Text("Aluno: ${sugestionListDynamic[index][2]}", style: nameStyle,),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 20),
                    child: Text("${sugestionListDynamic[index][1]}", style: freqStyle,),
                  ),
                ]),

                onTap: () async {
                  confirmPopUpDialog(context, sugestionListDynamic[index][0]);
                }
                  
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
                  child: Text("Sugestões",
                      style: titleStyle, textAlign: TextAlign.center)),
              SizedBox(height: screenHeight * 0.05),
              Container(
                width: 1200,
                height: screenHeight * 0.6,
                child: ListView.builder(
                  itemCount: sugestionListDynamic.length,
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
