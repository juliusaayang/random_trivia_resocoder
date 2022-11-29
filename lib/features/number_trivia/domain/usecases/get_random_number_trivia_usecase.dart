import 'package:random_trivia_resocoder/core/error/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:random_trivia_resocoder/core/usecase/usecase.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetRandomNumberTriviaUsecase
    extends Usecase<NumberTriviaEntity, NoParams> {
  final NumberTriviaRepository numberTriviaRepository;
  GetRandomNumberTriviaUsecase({
    required this.numberTriviaRepository,
  });
  @override
  Future<Either<Failure, NumberTriviaEntity>> call(NoParams params) {
    return numberTriviaRepository.getRandomNumberTrivia();
  }
}
