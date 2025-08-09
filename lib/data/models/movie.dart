import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

@JsonSerializable()
@HiveType(typeId: 0)
class MovieResponse extends HiveObject {
  @HiveField(0)
  int? page;

  @HiveField(1)
  List<Movie> results;

  @HiveField(2)
  int? totalPages;

  @HiveField(3)
  int? totalResults;

  MovieResponse({
    this.page,
    this.results = const [],
    this.totalPages,
    this.totalResults,
  });

  factory MovieResponse.fromJson(Map<String, dynamic> json) =>
      _$MovieResponseFromJson(json);
  Map<String, dynamic> toJson() => _$MovieResponseToJson(this);
}

@JsonSerializable()
@HiveType(typeId: 1)
class Movie extends HiveObject {
  @HiveField(0)
  bool? adult;

  @JsonKey(name: 'backdrop_path')
  @HiveField(1)
  String? backdropPath;

  @HiveField(2)
  List<int>? genreIds;

  @HiveField(3)
  int id;

  @JsonKey(name: 'original_language')
  @HiveField(4)
  String? originalLanguage;

  @JsonKey(name: 'original_title')
  @HiveField(5)
  String? originalTitle;

  @HiveField(6)
  String? overview;

  @HiveField(7)
  double? popularity;

  @HiveField(8)
  @JsonKey(name: 'poster_path')
  String? posterPath;

  @JsonKey(name: 'release_date')
  @HiveField(9)
  String? releaseDate;

  @HiveField(10)
  String? title;

  @HiveField(11)
  bool? video;

  @JsonKey(name: 'vote_average')
  @HiveField(12)
  double? voteAverage;

  @JsonKey(name: 'vote_countd')
  @HiveField(13)
  int? voteCount;

  @HiveField(14)
  bool isBookmark;

  Movie({
    this.adult,
    this.backdropPath,
    this.genreIds,
    required this.id,
    this.originalLanguage,
    this.originalTitle,
    this.overview,
    this.popularity,
    this.posterPath,
    this.releaseDate,
    this.title,
    this.video,
    this.voteAverage,
    this.voteCount,
    this.isBookmark = false,
  });

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);
  Map<String, dynamic> toJson() => _$MovieToJson(this);

  Movie copyWith({
    bool? adult,
    String? backdropPath,
    List<int>? genreIds,
    int? id,
    String? originalLanguage,
    String? originalTitle,
    String? overview,
    double? popularity,
    String? posterPath,
    String? releaseDate,
    String? title,
    bool? video,
    double? voteAverage,
    int? voteCount,
    bool? isBookmark,
  }) {
    return Movie(
      adult: adult ?? this.adult,
      backdropPath: backdropPath ?? this.backdropPath,
      genreIds: genreIds ?? this.genreIds,
      id: id ?? this.id,
      originalLanguage: originalLanguage ?? this.originalLanguage,
      originalTitle: originalTitle ?? this.originalTitle,
      overview: overview ?? this.overview,
      popularity: popularity ?? this.popularity,
      posterPath: posterPath ?? this.posterPath,
      releaseDate: releaseDate ?? this.releaseDate,
      title: title ?? this.title,
      video: video ?? this.video,
      voteAverage: voteAverage ?? this.voteAverage,
      voteCount: voteCount ?? this.voteCount,
      isBookmark: isBookmark ?? this.isBookmark,
    );
  }
}
