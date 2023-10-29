import 'package:flutter/material.dart';
import 'create_discipline.dart';
import 'list_students_discipline.dart';
import 'user_information.dart';
import 'create_row_call.dart';
import 'main.dart';

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
      UserInformationPageState(emailUser: widget.emailUser)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {

    String emailUser = widget.emailUser;

    final widgetOptions = getWidgetOptions();

    return Scaffold(
      appBar: AppBar(
        title:
            Text('Bem-vindo, $emailUser'),
      ),
      body: Center(
        child: widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromARGB(255, 162, 236, 201),
        unselectedItemColor: Colors.white,
        iconSize: 30,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Criar matérias',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.storage),
            label: 'Lista de alunos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_rounded),
            label: 'Gerar Chamada',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.art_track),
            label: 'Cadastro',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Usuário',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

}