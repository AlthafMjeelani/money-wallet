import 'package:flutter/material.dart';

class NoDataFound extends StatelessWidget {
  const NoDataFound({
    Key? key,
    required this.text,
  }) : super(key: key);
  final String text;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/assets/images/no result.gif'),
          ),
        ),
        width: 300,
        height: 300,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            text,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
    );
  }
}
