import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_trivia_resocoder/core/error/exceptions.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/models/number_trivia_model.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_datasource_test.mocks.dart';

@GenerateMocks([
  http.Client,
])
void main() {
  late NumberTriviaRemoteDatasourceImpl numberTriviaRemoteDatasourceImpl;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    numberTriviaRemoteDatasourceImpl = NumberTriviaRemoteDatasourceImpl(
      client: mockClient,
    );
  });

  void setupMockHttpClientSuccess200() =>
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) => Future.value(
          http.Response(fixture('trivia.json'), 200),
        ),
      );

  void setUpMockHttpClientFailure400() =>
      when(mockClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) => Future.value(
          http.Response('something went wrong', 404),
        ),
      );

  group('getConcreteNuberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL
    with number being the endpoint and with application/json header''',
      () {
        // arrange
        setupMockHttpClientSuccess200();

        // act
        numberTriviaRemoteDatasourceImpl.getConcreteNumberTrivia(tNumber);

        // assert
        verify(
          mockClient.get(
            Uri.parse('https://numbersapi.com/$tNumber'),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return a NumberTriviaModel when status code is 200',
      () async {
        // arrange
        setupMockHttpClientSuccess200();
        // act
        final result = await numberTriviaRemoteDatasourceImpl
            .getConcreteNumberTrivia(tNumber);
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a [ServerException] when response code is 404 or other than 200',
      () async {
        // arrange
        setUpMockHttpClientFailure400();

        // act
        final call = numberTriviaRemoteDatasourceImpl.getConcreteNumberTrivia;

        // assert
        expect(
          () => call(tNumber),
          throwsA(
            TypeMatcher<ServerExcpetion>(),
          ),
        );
      },
    );
  });

  group('gerRandomNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));

    test(
      '''should perform a GET request on a URL
    with number being the endpoint and with application/json header''',
      () {
        // arrange
        setupMockHttpClientSuccess200();

        // act
        numberTriviaRemoteDatasourceImpl.getRandomNumberTrivia();

        // assert
        verify(
          mockClient.get(
            Uri.parse('https://numbersapi.com/random'),
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
      },
    );

    test(
      'should return a NumberTriviaModel when status code is 200',
      () async {
        // arrange
        setupMockHttpClientSuccess200();
        // act
        final result =
            await numberTriviaRemoteDatasourceImpl.getRandomNumberTrivia();
        // assert
        expect(result, equals(tNumberTriviaModel));
      },
    );

    test(
      'should throw a [ServerException] when response code is 404 or other than 200',
      () async {
        // arrange
        setUpMockHttpClientFailure400();

        // act
        final call = numberTriviaRemoteDatasourceImpl.getRandomNumberTrivia;

        // assert
        expect(
          () => call(),
          throwsA(
            TypeMatcher<ServerExcpetion>(),
          ),
        );
      },
    );
  });
}
