import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/platforms/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/data_sources/number_trivia_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';

class MockNumberTriviaLocalDataSource extends Mock
    implements NumberTriviaLocalDataSource {}

class MockNumberTriviaRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  MockNumberTriviaLocalDataSource numberTriviaLocalDataSource;
  MockNumberTriviaRemoteDataSource numberTriviaRemoteDataSource;
  MockNetworkInfo networkInfo;

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
}
