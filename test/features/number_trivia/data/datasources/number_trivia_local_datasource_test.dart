import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_trivia_resocoder/core/error/exceptions.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_datasource_test.mocks.dart';

@GenerateMocks([
  SharedPreferences,
])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDataSourceImpl numberTriviaLocalDatasourceImpl;

  setUp(
    () {
      mockSharedPreferences = MockSharedPreferences();
      numberTriviaLocalDatasourceImpl = NumberTriviaLocalDataSourceImpl(
        sharedPreferences: mockSharedPreferences,
      );
    },
  );

  group(
    'getLastNumberTrivia',
    () {
      final tNumberTriviaModel = NumberTriviaModel.fromJson(
        jsonDecode(
          fixture('trivia_cache.json'),
        ),
      );
      test(
        'should return NumberTriviaModel from shared prefereces',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(
            fixture(
              'trivia_cache.json',
            ),
          );

          // act
          final result =
              await numberTriviaLocalDatasourceImpl.getLastNumberTrivia();
          //assert
          verify(
            mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA),
          );
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should throw a CecheException when there is no cached value',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(null);

          // act
          final call = numberTriviaLocalDatasourceImpl.getLastNumberTrivia;
          //assert
          expect(
            () => call(),
            throwsA(
              TypeMatcher<CacheException>(),
            ),
          );
        },
      );
    },
  );

  group(
    'cacheNumberTriva',
    () {
      final tNumberTriviaModel = NumberTriviaModel(
        text: 'test',
        number: 1,
      );
      test(
        'should call shared preferences to cache the data',
        () {
          // arrange
          when(mockSharedPreferences.setString(any, any)).thenAnswer(
            (realInvocation) => Future.value(true),
          );
          // act
          numberTriviaLocalDatasourceImpl.cacheNumberTrivia(
            tNumberTriviaModel,
          );

          // assert
          final expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
          verify(
            mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA,
              expectedJsonString,
            ),
          );
        },
      );
    },
  );
}
