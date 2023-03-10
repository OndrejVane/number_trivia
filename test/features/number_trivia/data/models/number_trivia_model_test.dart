import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixtures_reader.dart';

void main() {
  NumberTriviaModel tNumberTrivia =
      const NumberTriviaModel(number: 1, text: "Test text");

  test("Should be a subclass of NumberTrivia entitiy.", () async {
    // Assertion
    expect(tNumberTrivia, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test("Should return a valid model when the Json number is an integer.",
        () async {
      // Arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture("trivia_int.json"));

      // Act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // Assert
      expect(result, tNumberTrivia);
    });

    test("Should return a valid model when the Json number is an double.",
        () async {
      // Arrange
      final Map<String, dynamic> jsonMap =
          json.decode(fixture("trivia_double.json"));

      // Act
      final result = NumberTriviaModel.fromJson(jsonMap);

      // Assert
      expect(result, tNumberTrivia);
    });
  });

  group("toJson", () {
    test("Should return Json map containing the proper data", () async {
      // Arrange
      // nothing

      // Act
      final result = tNumberTrivia.toJson();

      // Assert
      final expectedMap = {
        'text': 'Test text',
        'number': 1,
      };

      expect(result, expectedMap);
    });
  });
}
