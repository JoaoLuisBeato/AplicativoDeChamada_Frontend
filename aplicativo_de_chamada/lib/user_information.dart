import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserInformationPageState extends StatefulWidget {

  final String emailUser;

  const UserInformationPageState({super.key, required this.emailUser});

  @override
  UserInformationPage createState() => UserInformationPage();

}

class UserInformationPage extends State<UserInformationPageState> {

  late double screenHeight;
  Map<String, dynamic> userInformationToDisplay = {};

  @override
  void initState(){
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {

    final url = Uri.parse('https://chamada-backend-develop.onrender.com/ReturnInfoGerais');

    final response = await http.post(url , body: {
              'email': widget.emailUser,
            });

    setState(() {
      userInformationToDisplay = json.decode(response.body);
    });
  }

  @override
  Widget build(BuildContext context){
    screenHeight = MediaQuery.of(context).size.height;

    TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.07,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    TextStyle style = TextStyle(
      fontSize: screenHeight * 0.02, fontWeight: FontWeight.normal, color: Colors.black);

    return Scaffold(
       body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                  alignment: Alignment.center,
                  child: Text("Informações",
                      style: titleStyle, textAlign: TextAlign.center)),
              SizedBox(height: screenHeight * 0.06),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Alinha à esquerda
                children: [
                Text("Nome: ${userInformationToDisplay['user_nome']}", style: style,),
              SizedBox(height: screenHeight * 0.04),
                Text("Registro: ${userInformationToDisplay['user_RegisterNumber']}", style: style),
              SizedBox(height: screenHeight * 0.04),
                Text("Email: ${userInformationToDisplay['user_email']}", style: style),
              SizedBox(height: screenHeight * 0.04),
              ]),
              Image.asset(
                "assets/images/classroom.png", // Substitua pelo caminho correto da sua imagem
                width:
                    900, // Defina a largura da imagem de acordo com suas preferências
                height:
                    300, // Defina a altura da imagem de acordo com suas preferências
              ),
            ],
          ),
        ),
    );
  }
}