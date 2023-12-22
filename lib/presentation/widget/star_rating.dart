import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;

  const StarRating({Key? key, required this.rating}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberOfStars = 5;
    double singleStarRating = rating / 2;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        numberOfStars,
        (index) {
          if (index + 1 <= singleStarRating) {
            return const Icon(Icons.star,
                color: Color.fromARGB(255, 202, 169, 20));
          } else if (singleStarRating > index && singleStarRating < index + 1) {
            return const Icon(Icons.star_half,
                color: Color.fromARGB(255, 202, 169, 20));
          } else {
            return const Icon(Icons.star_border,
                color: Color.fromARGB(255, 202, 169, 20));
          }
        },
      ).toList(),
    );
  }
}
