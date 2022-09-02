import 'package:dartz/dartz.dart';
import 'package:random_trivia_resocoder/core/error/failure.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTriviaUsecase {
  final NumberTriviaRepository numberTriviaRepository;
  GetConcreteNumberTriviaUsecase({
    required this.numberTriviaRepository,
  });

  Future<Either<Failure, NumberTriviaEntity>> call({
    required int number,
  }) {
    return numberTriviaRepository.getConcreteNumberTrivia(number: number);
  }
}
