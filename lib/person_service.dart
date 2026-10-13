import 'package:app_2/models/person.dart';
import 'package:dio/dio.dart';
import 'package:result_dart/result_dart.dart';

class PersonService {
  new({required this._dio});

  final Dio _dio;

  Future<Result<List<Person>>> getPersons({String? seed, int? results}) async {
    try {
      final List<Person> persons = [];

      final response = await _dio.get('https://randomuser.me/api/?seed=$seed&results=$results');
      final resultMap = response.data as Map<String, dynamic>;
      final personsMapsList = resultMap['results'] as List;

      for (var personMap in personsMapsList) {
        final person = Person(
          gender: personMap['gender'],
          name: personMap['name']['title'],
          email: personMap['email'],
        );

        persons.add(person);
      }

      return Success(persons);
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}
