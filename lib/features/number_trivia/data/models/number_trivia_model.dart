import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';

class NumberTriviaModel extends NumberTriviaEntity {
  NumberTriviaModel({
    required String text,
    required int number,
  }) : super(
          number: number,
          text: text,
        );

  factory NumberTriviaModel.fromJson(Map<String, dynamic> json) {
    return NumberTriviaModel(
      text: json['text'] as String,
      number: (json['number'] as num).toInt(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'number': number,
    };
  }
}
