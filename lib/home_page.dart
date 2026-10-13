import 'package:app_2/models/person.dart';
import 'package:app_2/person_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    this.title = 'Home Page',
    this.seed = 'test',
    this.results = 20,
  });

  final String title;
  final String seed;
  final int results;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ValueNotifier<List<Person>> _persons = ValueNotifier([]);

  late final PersonService _personService;
  late final _getPersonsCommand = Command2(_getPersons);

  @override
  void initState() {
    super.initState();
    _personService = PersonService(dio: Dio());

    Future.delayed(
      const Duration(milliseconds: 20),
      () async {
        await _getPersonsCommand.execute(widget.seed, widget.results);
        if (_getPersonsCommand.value.isSuccess) {
          final result = _getPersonsCommand.value as SuccessCommand<List<Person>>;
          _persons.value = result.value;
        }
      },
    );
  }

  AsyncResult<List<Person>> _getPersons(String? seed, int? results) {
    return _personService.getPersons(seed, results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: AnimatedBuilder(
        animation: _getPersonsCommand,
        builder: (_, _) {
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
                            ? Icon(Icons.woman, color: Colors.redAccent) //
                            : Icon(Icons.man, color: Colors.deepPurple),
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
