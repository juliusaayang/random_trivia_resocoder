import 'package:dartz/dartz.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/usecases/get_concreate_number_trivia_usecase.dart';

import 'get_concrete_number_trivia_usecase_test.mocks.dart';

@GenerateMocks([GetConcreteNumberTriviaUsecase, NumberTriviaRepository])
void main() {
  late GetConcreteNumberTriviaUsecase getConcreteNumberTriviaUsecase;
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late NumberTriviaEntity numberTriviaEntity;

  setUp(() async {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getConcreteNumberTriviaUsecase = GetConcreteNumberTriviaUsecase(
      numberTriviaRepository: mockNumberTriviaRepository,
    );

    numberTriviaEntity = NumberTriviaEntity(
      text: 'test',
      number: 2,
    );
  });


  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository.getConcreteNumberTrivia(any)).thenAnswer(
        (_) async => Right(
          numberTriviaEntity,
        ),
      );

      // act
      final result = await getConcreteNumberTriviaUsecase(
        GetConcreteNumberTriviaParams(number: 1)
      );

      // assert
      expect(
        result,
        Right(numberTriviaEntity),
      );

      verify(
        mockNumberTriviaRepository.getConcreteNumberTrivia(any),
      );

      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
