import 'package:flutter/material.dart';
import 'disciplines_list.dart';
import 'user_information.dart';

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

    final widgetOptions = getWidgetOptions();
    String emailUser = widget.emailUser;

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
            icon: Icon(Icons.check),
            label: 'Matérias',
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