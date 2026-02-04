# Flutter Movie Clean Architecture
[![Flutter](https://img.shields.io/badge/Flutter-3.24.1-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8.0-blue.svg?logo=dart)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.6.1-brightgreen?logo=flutter)](https://riverpod.dev)
[![Localization](https://img.shields.io/badge/Localization-English_&_Spanish-blue)](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)
![badge-Android](https://img.shields.io/badge/Platform-Android-brightgreen)
![badge-iOS](https://img.shields.io/badge/Platform-iOS-lightgray)
[![GitHub license](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0)
<a href="https://github.com/piashcse"><img alt="GitHub" src="https://img.shields.io/static/v1?label=GitHub&message=piashcse&color=C51162"/></a>

Flutter Movie App built with Riverpod, Clean Architecture, and GoRouter that showcases movies and TV series fetched from TMDB API. It includes now playing, popular, top-rated, and upcoming Movies, TV series and Celebrity with support for pagination, search, and detailed views.

<p align="center">
  <img width="30%" src="https://github.com/piashcse/flutter-movie-clean-architecture/blob/main/screen_shots/flutter_movie_1.png" />
  <img width="30%" src="https://github.com/piashcse/flutter-movie-clean-architecture/blob/main/screen_shots/flutter_movie_2.png" />
   <img width="30%" src="https://github.com/piashcse/flutter-movie-clean-architecture/blob/main/screen_shots/flutter_movie_3.png" />
</p>
<p align="center">
  <img width="30%" src="https://github.com/piashcse/flutter-movie-clean-architecture/blob/main/screen_shots/flutter_movie_4.png" />
   <img width="30%" src="https://github.com/piashcse/flutter-movie-clean-architecture/blob/main/screen_shots/flutter_movie_5.png" />
  <img width="30%" src="https://github.com/piashcse/flutter-movie-clean-architecture/blob/main/screen_shots/flutter_movie_6.png" />
</p>

## ✨ Features

### Movies
- 🎞 Now Playing, Popular, Top Rated & Upcoming movie sections
- 🔍 Movie Detail Pages with Cast & Crew
- 🎯 Recommended Movies
- 🔍 Search Movies
- 👤 Artist/Actor Detail Page with navigation from movie cast
- ❤️ Favorite Movies (saved locally using Hive database)

### TV Series
- 📺 Airing Today, On The Air, Popular & Upcoming TV series sections
- 🔍 TV Series Detail Pages with Cast & Crew
- 🎯 Recommended TV Series
- 🔍 Search TV Series
- 👤 Artist/Actor Detail Page with navigation from TV series cast
- ❤️ Favorite TV Series (saved locally using Hive database)

### Celebrity
- 🌟 Popular and Trending Celebrities/Persons sections
- 🔍 Celebrity Search functionality
- 👤 Celebrity Detail Page with navigation from movie/tv cast
- ❤️ Favorite Celebrities (saved locally using Hive database)

### Common Features
- 📃 Pagination (infinite scroll)
- 🔄 Bottom Navigation
- 🌐 Multi-language Support with Localization (English & Spanish)
- 🧭 Declarative Routing with GoRouter
- 🧱 Clean Architecture (Presentation / Domain / Data)
- 🧪 Riverpod State Management
- 🌐 Network layer using Dio with Logging
- 🚀 Smooth UX with loading indicators
- ❤️ Favorite Management with Local Storage (Hive)

## 🏗️ Architecture

This project follows Clean Architecture principles with clear separation of concerns:

<p align="center">
  </br>
  <img width="80%" height="80%" src="https://github.com/piashcse/flutter-movie-clean-architecture/blob/main/screen_shots/flutter-clean-architecture.png" />
</p>
<p align="center">
<b>Fig. Clean Architecture </b>
</p>

### Layers:
- **Presentation Layer**: UI components, state management, and user interactions
- **Domain Layer**: Business logic, entities, and use cases
- **Data Layer**: External data sources (APIs, databases)

## 📁 Project Structure

```
flutter_movie_clean_architecture/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   └── app_constant.dart          # Application constants (API keys, URLs)
│   │   ├── hive/
│   │   │   ├── favorite_model.dart        # Favorite item model
│   │   │   ├── favorite_model.g.dart      # Generated Hive adapter
│   │   │   └── hive_helper.dart           # Hive database helper
│   │   ├── localization/
│   │   │   ├── app_localizations.dart     # Localization setup
│   │   │   └── localization_helper.dart   # Localization helper
│   │   ├── network/
│   │   │   └── dio_provider.dart          # Dio HTTP client configuration
│   │   ├── theme/
│   │   │   ├── app_theme.dart             # Theme definitions
│   │   │   ├── theme_providers.dart       # Theme state management
│   │   │   ├── theme_toggle_widget.dart   # Theme toggle widget
│   │   │   └── repository/
│   │   │       └── theme_repository.dart  # Theme repository interface
│   │   └── utils/
│   │       ├── pagination_consumer_state.dart # Pagination state management
│   │       └── utils.dart                 # Utility functions
│   ├── features/
│   │   ├── celebrity/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── celebrity_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── person_model.dart
│   │   │   │   │   └── person_list_response.dart
│   │   │   │   └── repositories/
│   │   │   │       └── celebrity_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── person.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── celebrity_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_popular_persons.dart
│   │   │   │       ├── get_trending_persons.dart
│   │   │   │       └── search_persons.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── celebrity_main_page.dart
│   │   │       │   ├── celebrity_search_page.dart
│   │   │       │   ├── popular_persons_page.dart
│   │   │       │   └── trending_persons_page.dart
│   │   │       ├── providers/
│   │   │       │   └── celebrity_provider.dart
│   │   │       └── widgets/
│   │   │           └── person_card.dart
│   │   ├── favorites/
│   │   │   └── favorites_page.dart
│   │   ├── movie/
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   └── movie_remote_data_source.dart
│   │   │   │   ├── models/
│   │   │   │   │   ├── movie_detail_model.dart
│   │   │   │   │   ├── movie_model.dart
│   │   │   │   │   └── credit_model.dart
│   │   │   │   └── repositories/
│   │   │   │       └── movie_repository_impl.dart
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   ├── movie.dart
│   │   │   │   │   ├── movie_detail.dart
│   │   │   │   │   ├── credit_entity.dart
│   │   │   │   │   └── artist_detail.dart
│   │   │   │   ├── repositories/
│   │   │   │   │   └── movie_repository.dart
│   │   │   │   └── usecases/
│   │   │   │       ├── get_all_artist_movies.dart
│   │   │   │       ├── get_movie_detail.dart
│   │   │   │       ├── get_movie_credits.dart
│   │   │   │       ├── get_movie_search.dart
│   │   │   │       ├── get_now_playing.dart
│   │   │   │       ├── get_popular.dart
│   │   │   │       ├── get_top_rated.dart
│   │   │   │       ├── get_up_coming.dart
│   │   │   │       ├── get_recommended_movie.dart
│   │   │   │       └── get_artist_detail.dart
│   │   │   └── presentation/
│   │   │       ├── pages/
│   │   │       │   ├── artist_detail_page.dart
│   │   │       │   ├── movie_detail_page.dart
│   │   │       │   ├── movie_main_page.dart
│   │   │       │   ├── now_playing_page.dart
│   │   │       │   ├── popular_page.dart
│   │   │       │   ├── top_rated_page.dart
│   │   │       │   └── up_coming_page.dart
│   │   │       ├── providers/
│   │   │       │   ├── movie_provider.dart
│   │   │       │   └── favorite_provider.dart
│   │   │       └── widgets/
│   │   │           └── movie_card.dart
│   │   └── tv_series/
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── tv_series_remote_data_source.dart
│   │       │   ├── models/
│   │       │   │   ├── tv_series_detail_model.dart
│   │       │   │   ├── tv_series_model.dart
│   │       │   │   └── tv_series_credit_model.dart
│   │       │   └── repositories/
│   │       │       └── tv_series_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   ├── tv_series.dart
│   │       │   │   ├── tv_series_detail.dart
│   │       │   │   └── tv_series_credit_entity.dart
│   │       │   ├── repositories/
│   │       │   │   └── tv_series_repository.dart
│   │       │   └── usecases/
│   │       │       ├── get_airing_today.dart
│   │       │       ├── get_on_the_air.dart
│   │       │       ├── get_popular_tv_series.dart
│   │       │       ├── get_upcoming_tv_series.dart
│   │       │       ├── get_tv_series_detail.dart
│   │       │       ├── get_tv_series_credits.dart
│   │       │       ├── get_recommended_tv_series.dart
│   │       │       └── get_tv_series_search.dart
│   │       └── presentation/
│   │           ├── pages/
│   │           │   ├── airing_today_page.dart
│   │           │   ├── on_the_air_page.dart
│   │           │   ├── popular_tv_series_page.dart
│   │           │   ├── tv_series_detail_page.dart
│   │           │   ├── tv_series_main_page.dart
│   │           │   └── upcoming_tv_series_page.dart
│   │           ├── providers/
│   │           │   └── tv_series_provider.dart
│   │           └── widgets/
│           │       └── tv_series_card.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── main_tab_page.dart
│   │   └── widgets/
│   │       └── universal_search.dart
│   ├── routing/
│   │   └── app_router.dart
│   └── main.dart
├── android/
├── assets/
├── build/
├── ios/
├── screen_shots/
├── test/
├── pubspec.yaml
├── pubspec.lock
├── analysis_options.yaml
├── .gitignore
└── README.md
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.24.1 or higher)
- Dart SDK (3.8.0 or higher)
- Git

### Installation

1. Clone the repository:
```bash
git clone git@github.com:piashcse/flutter-movie-clean-architecture.git
cd flutter-movie-clean-architecture
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (build runner):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This command generates code for:
- JsonSerializable (JSON serialization/deserialization)
- Hive adapters (local database models)

4. Run the app:
```bash
flutter run
```

After running the app, you can:
- Browse movies, TV series, and celebrities
- View detailed information about each item
- Save your favorite items using the heart icon on detail pages
- Access your saved favorites through the Favorites tab

## 🛠️ Built With

- [Flutter](https://flutter.dev) - Google's UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase
- [Riverpod](https://riverpod.dev) - A simple, composable, and testable state management solution for Flutter
- [GoRouter](https://pub.dev/packages/go_router) - Declarative routing package for Flutter, designed to work seamlessly with state management and deep linking
- [Dio](https://pub.dev/packages/dio) - A powerful HTTP client for Dart, supporting interceptors, global configuration, FormData, request cancellation, and more
- [JsonSerializable](https://pub.dev/packages/json_serializable) - Generates code for converting between Dart objects and JSON, making serialization easy
- [Flutter Localizations](https://flutter.dev/docs/development/accessibility-and-localization/internationalization) - Internationalization and localization support for multi-language applications
- [PrettyDioLogger](https://pub.dev/packages/pretty_dio_logger) - Pretty logging for Dio HTTP requests and responses
- [Hive](https://pub.dev/packages/hive) - Lightweight and blazing fast key-value database written in pure Dart
- [Hive Flutter](https://pub.dev/packages/hive_flutter) - Extension for Hive that enables Flutter specific features
- [CachedNetworkImage](https://pub.dev/packages/cached_network_image) - Displays network images with caching and placeholder support

## 👨‍💻 Developed By

<a href="https://twitter.com/piashcse" target="_blank">
  <img src="https://avatars.githubusercontent.com/piashcse" width="80" align="left">
</a>

**Mehedi Hassan Piash**

[![Twitter](https://img.shields.io/badge/-Twitter-1DA1F2?logo=x&logoColor=white&style=for-the-badge)](https://twitter.com/piashcse)
[![Medium](https://img.shields.io/badge/-Medium-00AB6C?logo=medium&logoColor=white&style=for-the-badge)](https://medium.com/@piashcse)
[![Linkedin](https://img.shields.io/badge/-LinkedIn-0077B5?logo=linkedin&logoColor=white&style=for-the-badge)](https://www.linkedin.com/in/piashcse/)
[![Web](https://img.shields.io/badge/-Web-0073E6?logo=appveyor&logoColor=white&style=for-the-badge)](https://piashcse.github.io/)
[![Blog](https://img.shields.io/badge/-Blog-0077B5?logo=readme&logoColor=white&style=for-the-badge)](https://piashcse.blogspot.com)

## 📄 License

```
Copyright 2025 piashcse (Mehedi Hassan Piash)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
