import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/data/remote/network_constants.dart';
import 'package:movies_app/model/film.dart';

class FilmListRow extends StatelessWidget {
  final Film film;

  const FilmListRow({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        //context.go(NavigationRoutes.DETAIL, extra: pokemonNetworkListItem.name);
      },
      child: Center(
        child: SizedBox(
          height: 100,
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: SizedBox(
                      height: 100,
                      child: film.posterPath != null
                          ? CachedNetworkImage(
                              imageUrl: NetworkConstants.IMAGES_PATH +
                                  film.posterPath!,
                              fit: BoxFit.cover,
                            )
                          : Image.asset("assets/images/default_movie.png"),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          film.title,
                          softWrap: true,
                          maxLines: 2,
                          textAlign: TextAlign.start,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Vote average : ${film.voteAverage}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Release date : ${film.releaseDate.year}",
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}