import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/util/input_convertor.dart';

void main() {
  late InputConvertor inputConvertor;

  setUp(() {
    inputConvertor = InputConvertor();
  });

  group('stringToUnsignedInt', () {
    test('Should return an integer when the string represents an unsigned integer', () {
      // Arrange
      const tStr = "123";
      // Act
      final result = inputConvertor.stringToUnsignedInteger(tStr);

      // Assert
      expect(result, const Right(123));
    });

    test('Should return an failure when the string is not an integer', () {
      // Arrange
      const tStr = "abc";
      // Act
      final result = inputConvertor.stringToUnsignedInteger(tStr);

      // Assert
      expect(result, Left(InvalidInputFailure()));
    });

    test('Should return an failure when the string is a negative number', () {
      // Arrange
      const tStr = "-123";
      // Act
      final result = inputConvertor.stringToUnsignedInteger(tStr);

      // Assert
      expect(result, Left(InvalidInputFailure()));
    });
  });
}