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
    const tNumberTriviaModel = NumberTriviaModel(text: "text trivia", number: tNumber);
    const tNumberTrivia = tNumberTriviaModel;
    test("Should check if device is online", () {
      // Arrange
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      // Act
      numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
      // Assert
      verify(networkInfo.isConnected);
    });
  });
}
