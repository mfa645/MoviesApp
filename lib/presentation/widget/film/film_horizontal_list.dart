import 'package:flutter/material.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/presentation/widget/film/film_list_column.dart';

class FilmHorizontalList extends StatelessWidget {
  final List<Film> films;
  final String title;

  const FilmHorizontalList(
      {super.key, required this.films, required this.title});

  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Text(
            title,
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent),
          ),
        ),
        if (films.isNotEmpty)
          SizedBox(
            height: 240,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: films.length,
                itemBuilder: (_, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FilmListColumn(
                      film: films[index],
                    ),
                  );
                }),
          )
        else
          const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          ),
      ],
    ));
  }
}
