import 'package:aplicativo_de_chamada/classes_student_was_absent.dart';
import 'package:flutter/material.dart';
import 'disciplines_list.dart';
import 'user_information.dart';
import 'presence_for_student.dart';
import 'detailed_presence_for_student.dart';
import 'classes_student_was_in.dart';
import 'student_complient.dart';
import 'list_sugestions_for_representant.dart';
import 'list_of_comments_for_student.dart';

class StudentPageStateCall extends StatefulWidget{

  final String emailUser;

  const StudentPageStateCall({super.key, required this.emailUser});

  @override
  StudentPage createState() => StudentPage();
}

class StudentPage extends State<StudentPageStateCall>{

  int _selectedIndex = 0;

  List<Widget> getWidgetOptions() {
    return [
      DisciplineListState(emailUser: widget.emailUser),
      ClassesStudentWasInListState(emailUser: widget.emailUser),
      ClassesStudentWasAbsentListState(emailUser: widget.emailUser),
      PresenceForStudentCheckState(emailUser: widget.emailUser),
      DetailedPresenceForStudentState(emailUser: widget.emailUser),
      SugestionScreenCreateState(emailUser: widget.emailUser),
      SugestionListForRepresentantState(emailUser: widget.emailUser),
      CommentsForStudentListState(emailUser: widget.emailUser),
      UserInformationPageState(emailUser: widget.emailUser),
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
              title: const Text('Matérias'),
              leading: const Icon(Icons.check),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Presente'),
              leading: const Icon(Icons.addchart_rounded),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Ausente'),
              leading: const Icon(Icons.clear_rounded),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Pegar presença'),
              leading: const Icon(Icons.add_circle_outline_rounded),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Frequência'),
              leading: const Icon(Icons.align_horizontal_left_rounded),
              onTap: () {
                setState(() {
                  _selectedIndex = 4;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sugestões'),
              leading: const Icon(Icons.bookmark_rounded),
              onTap: () {
                setState(() {
                  _selectedIndex = 5;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Sala'),
              leading: const Icon(Icons.attach_email_rounded),
              onTap: () {
                setState(() {
                  _selectedIndex = 6;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Justificativas de faltas'),
              leading: const Icon(Icons.comment_rounded),
              onTap: () {
                setState(() {
                  _selectedIndex = 7;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Usuário'),
              leading: const Icon(Icons.account_circle),
              onTap: () {
                setState(() {
                  _selectedIndex = 8;
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