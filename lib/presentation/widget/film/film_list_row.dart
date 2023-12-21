import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/data/remote/network_constants.dart';
import 'package:movies_app/model/film.dart';

class FilmListRow extends StatelessWidget {
  final Film film;
  final String route;
  const FilmListRow({super.key, required this.film, required this.route});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(route, extra: film.id);
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
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                color: Colors.blueAccent,
                                value: downloadProgress.progress,
                              ),
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
                        Row(children: [
                          const Icon(
                            Icons.star,
                            size: 16,
                          ),
                          Text(
                            "Vote average : ${film.voteAverage}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                        Row(children: [
                          const Icon(
                            Icons.calendar_month,
                            size: 16,
                          ),
                          Text(
                            "Release date : ${film.releaseDate.isEmpty ? "NA" : DateTime.parse(film.releaseDate).year}",
                            style: const TextStyle(
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
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
