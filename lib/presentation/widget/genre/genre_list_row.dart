import 'package:flutter/material.dart';
import 'package:movies_app/model/genre.dart';

class GenreListRow extends StatelessWidget {
  final Genre genre;
  const GenreListRow({super.key, required this.genre});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
          height: 100,
          child: Card(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            elevation: 12,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: Image.asset("assets/images/genre_card_background.jpg")
                      .image,
                  fit: BoxFit.cover,
                ),
              ),
              child: Stack(children: [
                Container(
                  width: 380,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.50),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
                Positioned(
                    bottom: 60,
                    right: 0,
                    left: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        genre.name,
                        softWrap: true,
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Color.fromARGB(144, 0, 0, 0)),
                          ],
                        ),
                      ),
                    ))
              ]),
            ),
          )),
    );
  }
}
