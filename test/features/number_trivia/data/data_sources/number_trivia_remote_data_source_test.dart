import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixtures_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateNiceMocks([MockSpec<http.Client>()])
import 'package:http/http.dart' as http;

void main() {
  late NumberTriviaRemoteDataSourceImpl numberTriviaLocalDataSource;
  late MockClient httpClient;

  setUp(() {
    httpClient = MockClient();
    numberTriviaLocalDataSource = NumberTriviaRemoteDataSourceImpl(httpClient: httpClient);
  });

  void setUpMockHttpClientSuccess() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response(fixture('trivia_int.json'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(httpClient.get(any, headers: anyNamed('headers')))
        .thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia_int.json")));

    test(
        'Should perform get request to URL with concrete number being th endpoint and with application/json header',
        () {
      // Arrange
      setUpMockHttpClientSuccess();

      // Act
      numberTriviaLocalDataSource.getConcreteNumberTrivia(tNumber);

      // Assert
      verify(httpClient.get(Uri.http('numbersapi.com', '$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('Should return NumberTriviaModel if response code is 200 (success)', () async {
      // Arrange
      setUpMockHttpClientSuccess();

      // Act
      final result = await numberTriviaLocalDataSource.getConcreteNumberTrivia(tNumber);

      // Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('Should throw Server Exception when response code is not equals 200', () async {
      // Arrange
      setUpMockHttpClientFailure();

      // Act
      final call = numberTriviaLocalDataSource.getConcreteNumberTrivia;

      // Assert
      expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia_int.json")));

    test('Should perform get request to random endpoint and with application/json header', () {
      // Arrange
      setUpMockHttpClientSuccess();

      // Act
      numberTriviaLocalDataSource.getRandomNumberTrivia();

      // Assert
      verify(httpClient.get(Uri.http('numbersapi.com', 'random'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('Should return NumberTriviaModel if response code is 200 (success)', () async {
      // Arrange
      setUpMockHttpClientSuccess();

      // Act
      final result = await numberTriviaLocalDataSource.getRandomNumberTrivia();

      // Assert
      expect(result, equals(tNumberTriviaModel));
    });

    test('Should throw Server Exception when response code is not equals 200', () async {
      // Arrange
      setUpMockHttpClientFailure();

      // Act
      final call = numberTriviaLocalDataSource.getRandomNumberTrivia;

      // Assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
