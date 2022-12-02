import 'package:random_trivia_resocoder/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  /// Gets the cache [NumberTriviaModel] which was gotten the last time
  /// the user had internet connection
  /// 
  /// Throws a [CacheException] if no cache data is present
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}
