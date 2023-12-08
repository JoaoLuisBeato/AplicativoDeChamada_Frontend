import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommentsForStudentListState extends StatefulWidget {
  final String emailUser;

  const CommentsForStudentListState({super.key, required this.emailUser});

  @override
  State<CommentsForStudentListState> createState() => CommentsForStudentList();
}

class CommentsForStudentList extends State<CommentsForStudentListState> {
  late double screenHeight;
  late double fontSizeAsPercentage;
  late TextStyle titleStyle;

  bool subscribeButtonVisibility = true;

  List<dynamic> dataListCommentsForStudents = [];

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
            'https://chamada-backend-sy8c.onrender.com/return_Reposicoes'),
        body: {
          'Email': widget.emailUser,
        });

    setState(() {
      dataListCommentsForStudents = json.decode(response.body);
    });
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
                child: Text(dataListCommentsForStudents[index]['CodigoMateria'].toString(),
                    style: style),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 10, right: 10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "Código: ${dataListCommentsForStudents[index]['CodigoPresenca']}",
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
                    child: Text("Status: ${dataListCommentsForStudents[index]['Status']}",
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 10),
                    child: Text("Motivo: ${dataListCommentsForStudents[index]['Motivo']}"),
                  ),
                ]),
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
          itemCount: dataListCommentsForStudents.length,
          itemBuilder: (context, index) {
        return returnListTile(index);
      },
    ));
  }
}
