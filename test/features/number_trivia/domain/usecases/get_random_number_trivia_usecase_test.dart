import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:random_trivia_resocoder/core/usecase/usecase.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/usecases/get_random_number_trivia_usecase.dart';

import 'get_concrete_number_trivia_usecase_test.mocks.dart';

@GenerateMocks([NumberTriviaRepository])
void main() {
  late MockNumberTriviaRepository mockNumberTriviaRepository;
  late GetRandomNumberTriviaUsecase getRandomNumberTriviaUsecase;
  late NumberTriviaEntity numberTriviaEntity;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    getRandomNumberTriviaUsecase = GetRandomNumberTriviaUsecase(
        numberTriviaRepository: mockNumberTriviaRepository);
    numberTriviaEntity = NumberTriviaEntity(
      text: 'trivia',
      number: 2,
    );
  });

  test('Should get trivia from the repository', () async {
    when(mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer(
      (realInvocation) async => Right(numberTriviaEntity),
    );

    final result = await getRandomNumberTriviaUsecase(
      NoParams(),
    );

    expect(
      result,
      Right(numberTriviaEntity),
    );

    verify(
      mockNumberTriviaRepository.getRandomNumberTrivia(),
    );

    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
