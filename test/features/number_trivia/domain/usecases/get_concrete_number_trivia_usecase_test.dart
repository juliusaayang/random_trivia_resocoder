import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/usecases/get_concreate_number_trivia_usecase.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTriviaUsecase? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTriviaUsecase(
      numberTriviaRepository: mockNumberTriviaRepository!,
    );
  });

  final tNumber = 3;
  final tNumberTrivia = NumberTriviaEntity(
    text: 'test',
    number: tNumber,
  );

  test(
    'should get trivia for the number from the repository',
    () async {
      // arrange
      when(mockNumberTriviaRepository!.getConcreteNumberTrivia(
        number: 5,
      )).thenAnswer(
        (realInvocation) async => Right(
          tNumberTrivia,
        ),
      );

      // act
      final result = await usecase!.call(
        number: tNumber,
      );

      // assert
      expect(
        result,
        Right(tNumberTrivia),
      );

      verify(
        mockNumberTriviaRepository!.getConcreteNumberTrivia(number: tNumber),
      );

      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
