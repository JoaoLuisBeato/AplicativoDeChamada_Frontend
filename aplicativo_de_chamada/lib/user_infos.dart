import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserInfosCreateState extends StatefulWidget {

  String emailUser = '';
  UserInfosCreateState({super.key, required this.emailUser});

  @override
  State<UserInfosCreateState> createState() => UserInfosState();
}

class UserInfosState extends State<UserInfosCreateState>{
  late double screenHeight;

  String userName = "";
  String userEmail = "";
  int userRegistration = 0;

  @override
  void initState(){
    super.initState();
    fetchUserInfos();
  }

  Future<void> fetchUserInfos() async{
    final url = Uri.parse('http://10.0.2.2:5000/return_aluno');
    final response = await http.post(url, body: {'email': widget.emailUser});

    final jsonResponse = json.decode(response.body);

    setState(() {
      userRegistration = jsonResponse['aluno_RA'];
      userName = jsonResponse['aluno_nome'];
      userEmail = jsonResponse['aluno_email'];
    });
  } 

  @override
  Widget build(BuildContext context){

    screenHeight = MediaQuery.of(context).size.height;

    TextStyle titleStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black);

         TextStyle infoTextStyle = TextStyle(fontSize: screenHeight * 0.03,
         color: Colors.black);

    
    Text titleText(){
      return Text("Usuário", style: titleStyle);
    }

    Text userNamePrint(){
      return Text("Nome: $userName", style: infoTextStyle);
    }

    Text userEmailPrint(){
       return Text("Email: $userEmail", style: infoTextStyle);
    }

    Text userRegistrationPrint(){
       return Text("RA: $userRegistration", style: infoTextStyle);
    }

    return Scaffold(

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Align(alignment: Alignment.topCenter, 
              child: Text("Usuário", style: titleStyle)),
            const SizedBox(height: 30),
            userNamePrint(),
            const SizedBox(height: 20),
            userEmailPrint(),
            const SizedBox(height: 20),
            userRegistrationPrint()
          ],
        ),
      )
    );
  }
}