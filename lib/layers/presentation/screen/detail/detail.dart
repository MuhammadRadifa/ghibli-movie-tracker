import 'package:flutter/material.dart';
import 'package:ghibli_movies/layers/data/constant/app_color.dart';
import 'package:ghibli_movies/layers/data/provider/film_state.dart';
import 'package:ghibli_movies/layers/data/source/film_impl.dart';
import 'package:ghibli_movies/layers/data/source/network/api.dart';
import 'package:ghibli_movies/layers/domain/entity/film/film.dart';
import 'package:ghibli_movies/layers/domain/usecase/film_usecase.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  Future<Film>? _filmFuture;
  bool _isWatched = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();

    // Delay ambil filmId dari Provider setelah build context tersedia
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filmId = Provider.of<FilmState>(context, listen: false).filmId;

      if (filmId != null) {
        final api = ApiImpl();
        final repository = FilmImpl(api: api);
        final usecase = FilmUsecase(filmRepository: repository);

        setState(() {
          _filmFuture = usecase.getFilmById(filmId);
        });
      } else {
        setState(() {
          _filmFuture = Future.error('Film ID is null');
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _filmFuture == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Film>(
              future: _filmFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final film = snapshot.data!;
                  return _buildDetailContent(film);
                } else {
                  return const Center(child: Text('Film not found.'));
                }
              },
            ),
    );
  }

  Widget _buildDetailContent(Film film) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan gambar dan back button
          _buildHeader(film),

          // Konten utama
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title dan poster
                _buildTitleSection(film),

                const SizedBox(height: 16),

                // Action buttons
                _buildActionButtons(),

                const SizedBox(height: 10),

                // Description
                _buildDescriptionSection(film),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Film film) {
    return Container(
      height: 160,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.blue.shade900,
            Colors.blue.shade700,
            const Color(0xFF1E1E1E),
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background image (placeholder)
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(film.movieBanner),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(Film film) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Poster kecil
        Container(
          width: 120,
          height: 180,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              film.image,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: Colors.grey.shade800,
                child: const Icon(Icons.movie, color: Colors.grey, size: 50),
              ),
            ),
          ),
        ),

        const SizedBox(width: 16),

        // Title dan info
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                film.title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.star, size: 16, color: Colors.amber[700]),
                  const SizedBox(width: 6),
                  Text(
                    film.rtScore,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.camera_roll, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text(
                    '${film.runningTime} min',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.calendar_month, size: 16, color: Colors.grey[700]),
                  const SizedBox(width: 6),
                  Text(
                    film.releaseDate,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.blue[700]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Director: ${film.director}',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.business, size: 16, color: Colors.green[700]),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Producer: ${film.producer}',
                      style: const TextStyle(fontSize: 14),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        // Watched button
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                _isWatched = !_isWatched;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _isWatched ? Colors.green : Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(_isWatched ? Icons.check : Icons.play_arrow, size: 20),
                const SizedBox(width: 8),
                Text(
                  _isWatched ? 'Watched' : "I've Watched This",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Spacer between buttons

        // Favorite button
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _isFavorite = !_isFavorite;
              });
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: _isFavorite ? Colors.red : Colors.black,
              side: BorderSide(color: _isFavorite ? Colors.red : Colors.black),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _isFavorite ? 'Added to Favorites' : 'Add to Favorites',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionSection(Film film) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Description',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(film.description, style: TextStyle(fontSize: 14, height: 1.5)),
      ],
    );
  }
}
