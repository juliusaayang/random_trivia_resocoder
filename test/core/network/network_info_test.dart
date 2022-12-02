import 'package:flutter_test/flutter_test.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_trivia_resocoder/core/network/network_info.dart';

import 'network_info_test.mocks.dart';

@GenerateMocks([
  InternetConnectionChecker,
])
void main() {
  late MockInternetConnectionChecker mockInternetConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp(
    () {
      mockInternetConnectionChecker = MockInternetConnectionChecker();
      networkInfoImpl = NetworkInfoImpl(mockInternetConnectionChecker);
    },
  );

  group(
    'isConnected',
    () {
      test(
        'should forward the call to DataConection.hasConection',
        () {
          // arrange
          final tHasConnectionFuture = Future.value(true);

          when(mockInternetConnectionChecker.hasConnection).thenAnswer(
            (realInvocation) => tHasConnectionFuture,
          );

          // act
          final result = networkInfoImpl.isConnected;

          // assert
          verify(mockInternetConnectionChecker.hasConnection);
          expect(
            result,
            tHasConnectionFuture,
          );
        },
      );
    },
  );
}
