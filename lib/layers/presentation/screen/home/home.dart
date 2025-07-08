import 'package:flutter/material.dart';
import 'package:ghibli_movies/layers/data/constant/app_color.dart';
import 'package:ghibli_movies/layers/data/source/film_impl.dart';
import 'package:ghibli_movies/layers/data/source/network/api.dart';

import 'package:ghibli_movies/layers/domain/entity/film/film.dart';
import 'package:ghibli_movies/layers/domain/usecase/film_usecase.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.onItemTapped});

  final ValueChanged<String> onItemTapped;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Film>> _filmsFuture;

  @override
  void initState() {
    super.initState();
    final api = ApiImpl();
    final repository = FilmImpl(api: api);
    final usecase = FilmUsecase(filmRepository: repository);
    _filmsFuture = usecase.getAllFilms();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // Sticky header section using SliverPersistentHeader
          SliverPersistentHeader(
            pinned: true, // This makes it sticky
            delegate: _StickyHeaderDelegate(
              minHeight: isLandscape ? 80 : 100,
              maxHeight: isLandscape ? 180 : 280,
              child: Container(
                color: AppColors.background,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Adjust cover image height based on orientation
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16.0),
                          child: Image.asset(
                            'assets/image/cover.jpg',
                            height: isLandscape
                                ? 120
                                : 200, // Reduced height for landscape
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Image.asset(
                            'assets/image/totoro.png',
                            width: 50,
                            height: 50,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Ghibli Movie',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Films list as a sliver
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            sliver: FutureBuilder<List<Film>>(
              future: _filmsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (snapshot.hasError) {
                  return SliverFillRemaining(
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                }

                final films = snapshot.data ?? [];

                if (films.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('No films available.')),
                  );
                }

                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final film = films[index];
                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: isLandscape
                            ? _buildLandscapeLayout(film)
                            : _buildPortraitLayout(film),
                      ),
                    );
                  }, childCount: films.length),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPortraitLayout(Film film) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            film.image,
            width: 100,
            height: 160,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                film.title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              _buildFilmInfo(film),
              const SizedBox(height: 8),
              Text(
                film.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              _buildDetailsButton(film),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLandscapeLayout(Film film) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            film.image,
            width: 80, // Smaller image for landscape
            height: 120,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                film.title,
                style: const TextStyle(
                  fontSize: 16, // Slightly smaller title
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              _buildFilmInfo(film),
              const SizedBox(height: 6),
              Text(
                film.description,
                style: const TextStyle(fontSize: 13),
                maxLines: 2, // Fewer lines for landscape
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        // Button on the right for landscape
        SizedBox(
          width: 120,
          child: ElevatedButton(
            onPressed: () => widget.onItemTapped(film.id),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.remove_red_eye, color: Colors.white, size: 16),
                SizedBox(height: 2),
                Text(
                  'Details',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilmInfo(Film film) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 16),
            const SizedBox(width: 4),
            Text(film.rtScore, style: const TextStyle(fontSize: 14)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_roll, color: AppColors.primary, size: 16),
            const SizedBox(width: 4),
            Text(
              "${film.runningTime} Min",
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, size: 16),
            const SizedBox(width: 4),
            Text(film.releaseDate, style: const TextStyle(fontSize: 14)),
          ],
        ),
      ],
    );
  }

  Widget _buildDetailsButton(Film film) {
    return ElevatedButton(
      onPressed: () => widget.onItemTapped(film.id),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: AppColors.primary,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.remove_red_eye, color: Colors.white),
          SizedBox(width: 8),
          Text(
            'More Details',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

// Custom delegate for sticky header
class _StickyHeaderDelegate extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final Widget child;

  _StickyHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_StickyHeaderDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
