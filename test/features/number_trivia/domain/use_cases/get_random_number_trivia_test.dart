import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/use_cases/use_case.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mockito/annotations.dart';
import 'package:number_trivia/features/number_trivia/domain/use_cases/get_random_number_trivia.dart';

import 'get_concrete_number_trivia_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NumberTriviaRepository>()])
import 'package:number_trivia/features/number_trivia/domain/repositories/number_trivia_repository.dart';

void main() {
  late final GetRandomNumberTrivia usecase;
  late final NumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test(
    'should get random trivia from the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getRandomNumberTrivia())
          .thenAnswer((_) async => const Right(tNumberTrivia));

      // act
      final result = await usecase(NoParams());

      // assert
      expect(result, const Right(tNumberTrivia));
      // Verify that the method has been called on the Repository
      verify(mockNumberTriviaRepository.getRandomNumberTrivia());
      // Only the above method should be called and nothing more.
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
