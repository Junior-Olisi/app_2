import 'package:app_2/models/person.dart';
import 'package:app_2/person_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, this.title = 'Home Page'});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<List<Person>> _persons = ValueNotifier([]);

  late final PersonService _personService;
  late final Command0 _getPersonsCommand;

  @override
  void initState() {
    super.initState();
    _personService = PersonService(dio: Dio());
    _getPersonsCommand = Command0(_personService.getPersons);

    Future.delayed(
      const Duration(milliseconds: 100),
      () async {
        await _getPersonsCommand.execute();
        if (_getPersonsCommand.value.isFailure) {}
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).colorScheme.inversePrimary, title: Text(widget.title)),
      body: AnimatedBuilder(
        animation: _persons,
        builder: (_, __) {
          return _getPersonsCommand.value.isRunning
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : _getPersonsCommand.value.isFailure
              ? Center(
                  child: Text('Erro ao obter Lista de pessoas.'),
                )
              : ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    Text('Persons List'),
                    ..._persons.value.map(
                      (person) => ListTile(
                        title: Text(person.name),
                        subtitle: Text(person.email),
                        trailing: person.gender == 'female'
                            ? Icon(Icons.woman, color: Colors.purpleAccent) //
                            : Icon(Icons.man, color: Colors.blueAccent),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
