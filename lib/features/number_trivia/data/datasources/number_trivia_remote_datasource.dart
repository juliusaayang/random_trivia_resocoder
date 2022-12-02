import 'package:random_trivia_resocoder/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDatasource {
  /// calls the https://numbersapi.com/{number} endpoint
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);
  
  /// calls the https://numbersapi.com/random endpoint
  /// 
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}
