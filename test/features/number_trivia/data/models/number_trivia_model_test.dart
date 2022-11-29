import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(
    number: 1,
    text: 'testing',
  );

  test(
    'should be a subclass of NumberTriviaEntity',
    () {
      // assert
      expect(
        tNumberTriviaModel,
        isA<NumberTriviaEntity>(),
      );
    },
  );

  group(
    'fromJson',
    () {
      test(
        'should return a valid model when the JSON number is an integer',
        () {
          // arrange
          final Map<String, dynamic> jsonMap = json.decode(
            fixture('trivia.json'),
          );

          // act
          final result = NumberTriviaModel.fromJson(jsonMap);

          // assert
          expect(result, tNumberTriviaModel);
        },
      );

      test(
        'should return a valid model when the JSON number is regarded as a double',
        () {
          // arrange
          final Map<String, dynamic> jsonMap = json.decode(
            fixture('trivia_double.json'),
          );

          // act
          final result = NumberTriviaModel.fromJson(jsonMap);

          // assert
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );

  group(
    'ToJson',
    () {
      test(
        'should return a Json Map containing the proper data',
        () {
          // act
          final result = tNumberTriviaModel.toJson();

          // assert
          final exepectedMap = {
            "text": "testing",
            "number": 1,
          };
          expect(
            result,
            exepectedMap,
          );
        },
      );
    },
  );
}
