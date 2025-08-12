import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart'; // generated file

@RestApi(baseUrl: "https://api.themoviedb.org/3")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  @GET("/movie/now_playing")
  Future<HttpResponse> fetchNowPlayingMovies(
    @Header("Authorization") String apiKey,
    @Query("page") String page,
    @Query("language") String language,
  );

  @GET("/trending/movie/day")
  Future<HttpResponse> fetchTrendingMovie(
    @Header("Authorization") String apiKey,
    @Query("language") String language,
  );

  @GET("/search/movie")
  Future<HttpResponse> fetchDebouncedSearchMovies(
    @Header("Authorization") String apiKey,
    @Query("page") String page,
    @Query("language") String language,
    @Query("query") String query,
  );
}
