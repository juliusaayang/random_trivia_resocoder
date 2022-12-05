import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:random_trivia_resocoder/core/utils/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group(
    'stringToUnAssignedInt',
    () {
      test(
        '''should return a string when the string represents 
      an unsigned integer''',
        () {
          // arrange
          final str = '222';

          // act
          final result = inputConverter.stringToUnassignedInteger(str);

          // assert
          expect(result, Right(222));
        },
      );

      test(
        'should throw [InvalidInputFailure] string is not an unasssign integer',
        () {
          // arrange
          final str = 'bbb';

          // act
          final result = inputConverter.stringToUnassignedInteger(str);

          // assert
          expect(
            result,
            Left(
              InvalidInputFailure(),
            ),
          );
        },
      );

      test(
        'should throw [InvalidInputFailure] string is not a nagative integer',
        () {
          // arrange
          final str = '−22';

          // act
          final result = inputConverter.stringToUnassignedInteger(str);

          // assert
          expect(
            result,
            Left(
              InvalidInputFailure(),
            ),
          );
        },
      );
      
    },
  );
}
