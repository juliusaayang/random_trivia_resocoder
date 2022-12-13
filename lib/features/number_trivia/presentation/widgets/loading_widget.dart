import 'package:flutter/material.dart';

class Loadingwidget extends StatelessWidget {
  const Loadingwidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
