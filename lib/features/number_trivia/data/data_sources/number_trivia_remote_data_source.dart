import 'dart:convert';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {

  final http.Client httpClient;

  NumberTriviaRemoteDataSourceImpl({required this.httpClient});

  Future<NumberTriviaModel> _getNumberTriviaFromUri(Uri uri) async {
    final response = await httpClient.get(uri, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number)  {
    return _getNumberTriviaFromUri(Uri.http('numbersapi.com', '$number'));
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    return _getNumberTriviaFromUri(Uri.http('numbersapi.com', 'random'));
  }
}