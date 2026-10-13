import 'package:app_2/models/person.dart';
import 'package:flutter/material.dart';

class PersonDetailPage extends StatefulWidget {
  const new({required this.person, super.key});

  final Person person;

  @override
  State<PersonDetailPage> createState() => _PersonDetailPageState();
}

class _PersonDetailPageState extends State<PersonDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        widget.person.name,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w200,
        ),
      ),
    );
  }
}
