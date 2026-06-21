import 'package:flutter_dotenv/flutter_dotenv.dart';

const baseUrl = "https://api.themoviedb.org/3/";
const imageUrl = "https://image.tmdb.org/t/p/w342/";

String get apiKey => dotenv.env['TMDB_API_KEY'] ?? '';
