import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks([MockSpec<DataConnectionChecker>()])
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/network/network_info.dart';

import 'network_info_test.mocks.dart';


void main() {

  late NetworkInfoImpl networkInfoImpl;
  late MockDataConnectionChecker dataConnectionChecker;

  setUp(() {
    dataConnectionChecker = MockDataConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(dataConnectionChecker);
  });
  
  group("isConnected", () {
    test("Should forward tha call to DataConnectionChecker.hasConnection ", () async {
      // Arrange
      final tHasConnectionFuture = Future.value(true);
      when(dataConnectionChecker.hasConnection).thenAnswer((_) => tHasConnectionFuture);

      // Act
      final result = networkInfoImpl.isConnected;

      // Assert
      verify(dataConnectionChecker.hasConnection);
      expect(result, tHasConnectionFuture);

    });
  });



}