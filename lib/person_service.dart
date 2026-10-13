import 'package:app_2/models/person.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

class PersonService {
  new({required this._dio});

  final Dio _dio;

  AsyncResult<List<Person>> getPersons(String? seed, int? results) async {
    try {
      final List<Person> persons = [];

      final response = await _dio.get('https://randomuser.me/api/?seed=$seed&results=$results');
      final resultMap = response.data as Map<String, dynamic>;
      final personsMapsList = resultMap['results'] as List;

      for (var personMap in personsMapsList) {
        final gender = personMap['gender'];
        final name = "${personMap['name']['first']} ${personMap['name']['last']}";
        final email = personMap['email'];

        final person = Person(
          gender: gender,
          name: name,
          email: email,
        );

        persons.add(person);
      }

      return Success(persons);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
