import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failure.dart';
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
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late MockNumberTriviaLocalDataSource numberTriviaLocalDataSource;
  late MockNumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  late MockNetworkInfo networkInfo;

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

  void setUpIsConnected(bool isConnected) {
    when(networkInfo.isConnected).thenAnswer((_) async => isConnected);
  }

  group("getConcreteNumberTrivia", () {
    /* Prepare tes data */
    const tNumber = 1;
    const tNumberTriviaModel = NumberTriviaModel(text: "text trivia", number: tNumber);
    const tNumberTrivia = tNumberTriviaModel;

    /* Tests */
    test("Should check if device is online", () {
      // Arrange
      setUpIsConnected(true);
      // Act
      numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
      // Assert
      verify(networkInfo.isConnected);
    });

    group("Device is online", () {
      setUp(() {
        setUpIsConnected(true);
      });

      test("Should return remote data source if device is online", () async {
        // Arrange
        when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(const Right(tNumberTrivia)));
      });

      test("Should cache the data locally when the call to remote data source is successful",
          () async {
        // Arrange
        when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((_) async => tNumberTriviaModel);
        // Act
        await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(numberTriviaLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });

      test("Should return server failure when the call to remote data source is unsuccessful",
          () async {
        // Arrange
        when(numberTriviaRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(ServerException());
        // Act
        final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
        // Assert
        verify(numberTriviaRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(numberTriviaLocalDataSource);
        expect(result, equals(Left(ServerFailure())));
      });
    });

    group("Device is offline", () {
      setUp(() {
        setUpIsConnected(false);
      });

      test("Should return last locally cached data when the cached data is present",
              () async {
            // Arrange
            when(numberTriviaLocalDataSource.getLastNumberTrivia())
                .thenAnswer((_) async => tNumberTriviaModel);
            // Act
            final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
            // Assert
            verify(numberTriviaLocalDataSource.getLastNumberTrivia());
            verifyZeroInteractions(numberTriviaRemoteDataSource);
            expect(result, equals(const Right(tNumberTrivia)));
          });

    test("Should return cached failure when the cached data is not present in local storage",
            () async {
          // Arrange
          when(numberTriviaLocalDataSource.getLastNumberTrivia())
              .thenThrow(CacheException());
          // Act
          final result = await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
          // Assert
          verify(numberTriviaLocalDataSource.getLastNumberTrivia());
          verifyZeroInteractions(numberTriviaRemoteDataSource);
          expect(result, equals(Left(CacheFailure())));
        });
    });
  });
}
