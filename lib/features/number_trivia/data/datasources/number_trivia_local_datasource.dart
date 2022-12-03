import 'dart:convert';

import 'package:random_trivia_resocoder/core/error/exceptions.dart';
import 'package:random_trivia_resocoder/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDatasource {
  /// Gets the cache [NumberTriviaModel] which was gotten the last time
  /// the user had internet connection
  ///
  /// Throws a [CacheException] if no cache data is present
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDatasource {
  final SharedPreferences sharedPreferences;
  const NumberTriviaLocalDataSourceImpl({
    required this.sharedPreferences,
  });

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTriviaModel) {
    return sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA,
      jsonEncode(
        numberTriviaModel.toJson(),
      ),
    );
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null) {
      return Future.value(
        NumberTriviaModel.fromJson(
          jsonDecode(
            jsonString,
          ),
        ),
      );
    } else {
      throw CacheException();
    }
  }
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';
