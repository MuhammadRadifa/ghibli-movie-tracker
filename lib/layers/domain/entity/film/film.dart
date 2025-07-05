class Film {
  final String id;
  final String title;
  final String originalTitle;
  final String originalTitleRomanised;
  final String image;
  final String movieBanner;
  final String description;
  final String director;
  final String producer;
  final String releaseDate;
  final int runningTime;
  final String rtScore;
  final String url;

  Film({
    required this.id,
    required this.title,
    required this.originalTitle,
    required this.originalTitleRomanised,
    required this.image,
    required this.movieBanner,
    required this.description,
    required this.director,
    required this.producer,
    required this.releaseDate,
    required this.runningTime,
    required this.rtScore,
    required this.url,
  });

  // empty film
  static Film empty() {
    return Film(
      id: '',
      title: '',
      originalTitle: '',
      originalTitleRomanised: '',
      image: '',
      movieBanner: '',
      description: '',
      director: '',
      producer: '',
      releaseDate: '',
      runningTime: 0,
      rtScore: '',
      url: '',
    );
  }
}
