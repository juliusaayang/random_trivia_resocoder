import 'package:flutter/material.dart';
import 'package:random_trivia_resocoder/features/number_trivia/domain/entities/number_trivia_entity.dart';

class TriviaWidget extends StatelessWidget {
  const TriviaWidget({
    Key? key,
    required this.numberTriviaEntity,
  }) : super(key: key);
  final NumberTriviaEntity numberTriviaEntity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      child: Column(
        children: [
          Text(
            numberTriviaEntity.number.toString(),
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  numberTriviaEntity.text.toString(),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
