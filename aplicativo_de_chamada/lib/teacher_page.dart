import 'package:flutter/material.dart';
import 'create_discipline.dart';
import 'list_students_discipline.dart';
import 'user_information.dart';
import 'create_row_call.dart';
import 'main.dart';
import 'list_of_comments_for_teacher.dart';

class TeacherPageStateCall extends StatefulWidget{

  final String emailUser;

  const TeacherPageStateCall({super.key, required this.emailUser});

  @override
  TeacherPage createState() => TeacherPage();
}

class TeacherPage extends State<TeacherPageStateCall>{

  int _selectedIndex = 0;

  List<Widget> getWidgetOptions() {
    return [
      DisciplineCreateState(emailUser: widget.emailUser),
      ListStudentsForEachDisciplineState(emailUser: widget.emailUser),
      RowCallCreateState(emailUser: widget.emailUser),
      const MyHomePage(),
      CommentsForTeacherListState(emailUser: widget.emailUser),
      UserInformationPageState(emailUser: widget.emailUser)
    ];
  }


 @override
  Widget build(BuildContext context) {
    final widgetOptions = getWidgetOptions();
    String emailUser = widget.emailUser;

    double screenHeight = MediaQuery.of(context).size.height;

    TextStyle drawerMenuStyle = TextStyle(
        fontFamily: 'DancingScript',
        fontSize: screenHeight * 0.05,
        fontWeight: FontWeight.bold,
        color: Colors.black);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bem-vindo, $emailUser'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
             DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 162, 236, 201),
              ),
              child: Text(
                'Menu',
                style: drawerMenuStyle,
              ),
            ),
            ListTile(
              title: const Text('Criar matérias'),
              leading: const Icon(Icons.edit),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Lista de alunos'),
              leading: const Icon(Icons.storage),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Gerar Chamada'),
              leading: const Icon(Icons.add_circle_outline_rounded),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Cadastro'),
              leading: const Icon(Icons.art_track),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context); 
              },
            ),
            ListTile(
              title: const Text('Justificativas de faltas'),
              leading: const Icon(Icons.align_horizontal_left_rounded),
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Usuário'),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                setState(() {
                  _selectedIndex = 5;
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

}