import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/data/remote/network_constants.dart';
import 'package:movies_app/model/film.dart';
import 'package:movies_app/presentation/navigation/navigation_routes.dart';

class FilmListColumn extends StatelessWidget {
  final Film film;

  const FilmListColumn({super.key, required this.film});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.go(NavigationRoutes.FILM_HOME_DETAIL_ROUTE, extra: film.id);
      },
      child: Center(
        child: SizedBox(
          height: 220,
          width: 120,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.0),
                child: SizedBox(
                  width: 120,
                  height: 160,
                  child: film.posterPath != null
                      ? CachedNetworkImage(
                          imageUrl:
                              NetworkConstants.IMAGES_PATH + film.posterPath!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset("assets/images/default_movie.png"),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                film.title,
                softWrap: true,
                maxLines: 2,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
