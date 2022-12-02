import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_trivia_resocoder/core/error/exceptions.dart';
import 'package:random_trivia_resocoder/core/error/failure.dart';
import 'package:random_trivia_resocoder/core/network/network_info.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
    [NumberTriviaRemoteDatasource, NumberTriviaLocalDatasource, NetWorkInfo])
void main() {
  late NumberTriviaRepositoryImpl numberTriviaRepositoryImpl;
  late MockNumberTriviaRemoteDatasource mockNumberTriviaRemoteDatasource;
  late MockNumberTriviaLocalDatasource mockNumberTriviaLocalDatasource;
  late MockNetWorkInfo mockNetWorkInfo;

  setUp(
    () {
      mockNumberTriviaRemoteDatasource = MockNumberTriviaRemoteDatasource();
      mockNumberTriviaLocalDatasource = MockNumberTriviaLocalDatasource();
      mockNetWorkInfo = MockNetWorkInfo();
      numberTriviaRepositoryImpl = NumberTriviaRepositoryImpl(
        netWorkInfo: mockNetWorkInfo,
        numberTriviaRemoteDatasource: mockNumberTriviaRemoteDatasource,
        numberTriviaLocalDatasource: mockNumberTriviaLocalDatasource,
      );
    },
  );

  void runTestOnline(Function body) {
    group(
      'device is online',
      () {
        setUp(() {
          when(mockNetWorkInfo.isConnected).thenAnswer(
            (realInvocation) => Future.value(true),
          );
        });
        body();
      },
    );
  }

  void runTestOffline(Function body) {
    group(
      'device is offline',
      () {
        setUp(() {
          when(mockNetWorkInfo.isConnected).thenAnswer(
            (realInvocation) => Future.value(false),
          );
        });
        body();
      },
    );
  }

  group(
    'getConcreteNuberTrivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel(
        text: 'test',
        number: 1,
      );
      final NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;
      test(
        'check if device is connected to the internet',
        () async {
          // arrange
          when(mockNetWorkInfo.isConnected).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          when(mockNumberTriviaRemoteDatasource.getConcreteNumberTrivia(any))
              .thenAnswer((realInvocation) async => tNumberTriviaModel);
          // act
          await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
          // assert
          verify(mockNetWorkInfo.isConnected);
        },
      );

      runTestOnline(
        () {
          test(
            'should return remote data when to call to the remote datasource is successful',
            () async {
              // arrange
              when(mockNumberTriviaRemoteDatasource
                      .getConcreteNumberTrivia(any))
                  .thenAnswer((realInvocation) async => tNumberTriviaModel);
              // act
              final result = await numberTriviaRepositoryImpl
                  .getConcreteNumberTrivia(tNumber);
              // assert
              verify(mockNumberTriviaRemoteDatasource
                  .getConcreteNumberTrivia(tNumber));
              expect(
                result,
                equals(Right(tNumberTriviaEntity)),
              );
            },
          );

          test(
            'should cache the data locally when to call to the remote datasource is successful',
            () async {
              // arrange
              when(mockNumberTriviaRemoteDatasource
                      .getConcreteNumberTrivia(any))
                  .thenAnswer(
                (realInvocation) => Future.value(tNumberTriviaModel),
              );
              // act
              await numberTriviaRepositoryImpl.getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                mockNumberTriviaRemoteDatasource
                    .getConcreteNumberTrivia(tNumber),
              );
              verify(
                mockNumberTriviaLocalDatasource.cacheNumberTrivia(
                  tNumberTriviaModel,
                ),
              );
            },
          );

          test(
            'should return server error when to call to the remote datasource is unsuccessful',
            () async {
              // arrange
              when(mockNumberTriviaRemoteDatasource
                      .getConcreteNumberTrivia(any))
                  .thenThrow(ServerExcpetion());
              // act
              final result = await numberTriviaRepositoryImpl
                  .getConcreteNumberTrivia(tNumber);
              // assert
              verify(
                mockNumberTriviaRemoteDatasource
                    .getConcreteNumberTrivia(tNumber),
              );
              verifyZeroInteractions(mockNumberTriviaLocalDatasource);
              expect(
                result,
                equals(
                  Left(
                    ServerFailure(),
                  ),
                ),
              );
            },
          );
        },
      );

      runTestOffline(
        () {
          test(
            'should return the last locally cached data when the cache is present',
            () async {
              // arrange
              when(mockNumberTriviaLocalDatasource.getLastNumberTrivia())
                  .thenAnswer(
                (realInvocation) => Future.value(tNumberTriviaModel),
              );
              // act

              final res = await numberTriviaRepositoryImpl
                  .getConcreteNumberTrivia(tNumber);

              // assert
              verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
              verify(mockNumberTriviaLocalDatasource.getLastNumberTrivia());
              expect(
                res,
                equals(
                  Right(
                    tNumberTriviaEntity,
                  ),
                ),
              );
            },
          );

          test(
            'should return [CacheFailure] when there is no cache present',
            () async {
              // arrange
              when(mockNumberTriviaLocalDatasource.getLastNumberTrivia())
                  .thenThrow(
                CacheException(),
              );
              // act

              final res = await numberTriviaRepositoryImpl
                  .getConcreteNumberTrivia(tNumber);

              // assert
              verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
              verify(mockNumberTriviaLocalDatasource.getLastNumberTrivia());
              expect(
                res,
                equals(
                  Left(
                    CacheFailure(),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );

  group(
    'getRandomTrivia',
    () {
      final tNumberTriviaModel = NumberTriviaModel(
        text: 'test',
        number: 1,
      );
      final NumberTriviaEntity tNumberTriviaEntity = tNumberTriviaModel;
      test(
        'check if device is connected to the internet',
        () async {
          // arrange
          when(mockNetWorkInfo.isConnected).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
              .thenAnswer((realInvocation) async => tNumberTriviaModel);
          // act
          await numberTriviaRepositoryImpl.getRandomNumberTrivia();
          // assert
          verify(mockNetWorkInfo.isConnected);
        },
      );

      runTestOnline(
        () {
          test(
            'should return remote data when to call to the remote datasource is successful',
            () async {
              // arrange
              when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
                  .thenAnswer((realInvocation) async => tNumberTriviaModel);
              // act
              final result =
                  await numberTriviaRepositoryImpl.getRandomNumberTrivia();
              // assert
              verify(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia());
              expect(
                result,
                equals(Right(tNumberTriviaEntity)),
              );
            },
          );

          test(
            'should cache the data locally when to call to the remote datasource is successful',
            () async {
              // arrange
              when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
                  .thenAnswer(
                (realInvocation) => Future.value(tNumberTriviaModel),
              );
              // act
              await numberTriviaRepositoryImpl.getRandomNumberTrivia();
              // assert
              verify(
                mockNumberTriviaRemoteDatasource.getRandomNumberTrivia(),
              );
              verify(
                mockNumberTriviaLocalDatasource.cacheNumberTrivia(
                  tNumberTriviaModel,
                ),
              );
            },
          );

          test(
            'should return server error when to call to the remote datasource is unsuccessful',
            () async {
              // arrange
              when(mockNumberTriviaRemoteDatasource.getRandomNumberTrivia())
                  .thenThrow(ServerExcpetion());
              // act
              final result =
                  await numberTriviaRepositoryImpl.getRandomNumberTrivia();
              // assert
              verify(
                mockNumberTriviaRemoteDatasource.getRandomNumberTrivia(),
              );
              verifyZeroInteractions(mockNumberTriviaLocalDatasource);
              expect(
                result,
                equals(
                  Left(
                    ServerFailure(),
                  ),
                ),
              );
            },
          );
        },
      );

      runTestOffline(
        () {
          test(
            'should return the last locally cached data when the cache is present',
            () async {
              // arrange
              when(mockNumberTriviaLocalDatasource.getLastNumberTrivia())
                  .thenAnswer(
                (realInvocation) => Future.value(tNumberTriviaModel),
              );
              // act

              final res =
                  await numberTriviaRepositoryImpl.getRandomNumberTrivia();

              // assert
              verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
              verify(mockNumberTriviaLocalDatasource.getLastNumberTrivia());
              expect(
                res,
                equals(
                  Right(
                    tNumberTriviaEntity,
                  ),
                ),
              );
            },
          );

          test(
            'should return [CacheFailure] when there is no cache present',
            () async {
              // arrange
              when(mockNumberTriviaLocalDatasource.getLastNumberTrivia())
                  .thenThrow(
                CacheException(),
              );
              // act

              final res =
                  await numberTriviaRepositoryImpl.getRandomNumberTrivia();

              // assert
              verifyZeroInteractions(mockNumberTriviaRemoteDatasource);
              verify(mockNumberTriviaLocalDatasource.getLastNumberTrivia());
              expect(
                res,
                equals(
                  Left(
                    CacheFailure(),
                  ),
                ),
              );
            },
          );
        },
      );
    },
  );
}
