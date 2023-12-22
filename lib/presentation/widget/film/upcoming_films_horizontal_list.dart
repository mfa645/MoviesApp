import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:movies_app/data/remote/network_constants.dart';
import 'package:movies_app/model/film.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class UpcomingFilmsHorizontalList extends StatefulWidget {
  final List<Film> films;
  final String route;

  const UpcomingFilmsHorizontalList(
      {super.key, required this.films, required this.route});

  @override
  State<UpcomingFilmsHorizontalList> createState() =>
      _UpcomingFilmsHorizontalListState();
}

class _UpcomingFilmsHorizontalListState
    extends State<UpcomingFilmsHorizontalList> {
  var upcomingIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Material(
        child: Column(
      children: [
        if (widget.films.isNotEmpty)
          SizedBox(
              height: 250,
              child: ScrollSnapList(
                itemBuilder: _buildListItem,
                itemCount: 10,
                itemSize: 380,
                onItemFocus: (index) {
                  upcomingIndex = index;
                  setState(() {});
                },
                dynamicItemSize: true,
              ))
        else
          const Center(
            child: CircularProgressIndicator(
              color: Colors.blueAccent,
            ),
          ),
        const SizedBox(
          height: 10,
        ),
        AnimatedSmoothIndicator(
          activeIndex: upcomingIndex,
          count: 10,
          effect: const WormEffect(
            activeDotColor: Colors.black54,
            dotHeight: 8,
            dotWidth: 8,
            type: WormType.thinUnderground,
          ),
        )
      ],
    ));
  }

  Widget _buildListItem(BuildContext context, int index) {
    Film film = widget.films[index];
    return GestureDetector(
      onTap: () {
        context.go(widget.route, extra: film.id);
      },
      child: SizedBox(
        width: 380,
        child: Card(
          color: Colors.transparent,
          elevation: 12,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: SizedBox(
                    height: 242,
                    child: film.backdropPath != null
                        ? CachedNetworkImage(
                            imageUrl: NetworkConstants.IMAGES_PATH +
                                film.backdropPath!,
                            fit: BoxFit.fitHeight,
                          )
                        : Image.asset(
                            "assets/images/movie_placeholder_horizontal.png"),
                  ),
                ),
                Container(
                  height: 242,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.30),
                      borderRadius: BorderRadius.circular(12)),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 200,
                          child: Text(
                            film.title,
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24),
                          ),
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
    );
  }
}
