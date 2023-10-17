import 'package:flutter/material.dart';
import 'create_discipline.dart';
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
      DisciplineCreateState(emailUser: widget.emailUser,),
      const MyHomePage()
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
            icon: Icon(Icons.edit),
            label: 'Cadastro',    //coloquei cadastro só para inicializar a bottombar
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }

}