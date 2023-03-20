import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import '../../../../fixtures/fixtures_reader.dart';
import 'number_trivia_local_data_source_test.mocks.dart';
import 'package:shared_preferences/shared_preferences.dart';

@GenerateNiceMocks([MockSpec<SharedPreferences>()])
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';

void main() {
  late NumberTriviaLocalDataSourceImpl numberTriviaLocalDataSource;
  late MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    numberTriviaLocalDataSource =
        NumberTriviaLocalDataSourceImpl(sharedPreferences: mockSharedPreferences);
  });


  group("getLastNumberTrivia", () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture("trivia_cached.json")));

    test("Should return NumberTrivia from Shared Preferences when there is one in the cache",
        () async {
      // Arrange
      when(mockSharedPreferences.getString(any))
          .thenAnswer((realInvocation) => fixture("trivia_cached.json"));

      // Act
      final result = await numberTriviaLocalDataSource.getLastNumberTrivia();

      // Assert
      verify(mockSharedPreferences.getString(KEY_CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));

    });

    test("Should throw cache exception if Shared Preferences are empty", () async {
      // Arrange
      when(mockSharedPreferences.getString(any)).thenReturn(null);

      // Act
      final call = numberTriviaLocalDataSource.getLastNumberTrivia;

      // Assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));

    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: "Test text", number: 1);
    test('Should store number trivia to shared preferences', () async {
      // Arrange
      // do nothing

      // Act
      await numberTriviaLocalDataSource.cacheNumberTrivia(tNumberTriviaModel);

      // Assert
      final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
      verify(mockSharedPreferences.setString(KEY_CACHED_NUMBER_TRIVIA, expectedJsonString));

    });
  });

}
