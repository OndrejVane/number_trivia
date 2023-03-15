import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NetworkInfo>()])
import 'package:number_trivia/core/platforms/network_info.dart';
@GenerateNiceMocks([MockSpec<NumberTriviaRemoteDataSource>()])
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
@GenerateNiceMocks([MockSpec<NumberTriviaLocalDataSource>()])
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';

void main() {
  late final NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late final MockNumberTriviaLocalDataSource numberTriviaLocalDataSource;
  late final MockNumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  late final MockNetworkInfo networkInfo;

  setUp(() {
    numberTriviaLocalDataSource = MockNumberTriviaLocalDataSource();
    numberTriviaRemoteDataSource = MockNumberTriviaRemoteDataSource();
    networkInfo = MockNetworkInfo();
    numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
      numberTriviaLocalDataSource: numberTriviaLocalDataSource,
      numberTriviaRemoteDataSource: numberTriviaRemoteDataSource,
      networkInfo: networkInfo,
    );
  });

  group("getConcreteNumberTrivia", () {
    const tNumber = 1;
    const tNumberTriviaModel =
        NumberTriviaModel(text: "text trivia", number: tNumber);
    const tNumberTrivia = tNumberTriviaModel;
    test("Should check if device is online", () {
      // Arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // Act
      numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
      // Assert
      verify(networkInfo.isConnected);
    });

    group("Device is online", () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => true);
      });

      test("Should return remote data source if device is online", () async {
        // Arrange
        when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        final result =
            await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });
    });

    group("Device is offline", () {
      setUp(() {
        when(networkInfo.isConnected).thenAnswer((_) async => false);
      });
    });
  });
}
