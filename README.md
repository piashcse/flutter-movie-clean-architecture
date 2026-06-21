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
- 🎞 Now Playing, Popular, Top Rated & Upcoming movie sections (paginated)
- 🔍 Movie Detail Pages with Cast & Crew
- 🎯 Recommended Movies
- 🔍 Search Movies (debounced)
- 👤 Artist/Actor Detail Page with navigation from movie cast
- ❤️ Favorite Movies (saved locally using Hive database)

### TV Series
- 📺 Airing Today, On The Air, Popular & Upcoming TV series sections (paginated)
- 🔍 TV Series Detail Pages with Cast & Crew
- 🎯 Recommended TV Series
- 🔍 Search TV Series (debounced)
- 👤 Artist/Actor Detail Page with navigation from TV series cast
- ❤️ Favorite TV Series (saved locally using Hive database)

### Celebrity
- 🌟 Popular and Trending Celebrities/Persons sections (paginated)
- 🔍 Celebrity Search functionality (debounced)
- 👤 Celebrity Detail Page with navigation from movie/tv cast
- ❤️ Favorite Celebrities (saved locally using Hive database)

### Common Features
- 📃 Infinite Scroll Pagination across all list views
- 🔄 Bottom Navigation with tab switching
- 🌐 Multi-language Support with Localization (English & Spanish)
- 🧭 Declarative Routing with GoRouter
- 🧱 Clean Architecture (Presentation / Domain / Data) — no empty abstraction layers
- 🧪 Riverpod State Management
- 🌐 Network layer using Dio with Logging
- 🚀 Smooth UX with loading indicators and cached images
- ❤️ Favorite Management with Local Storage (Hive)
- 🎨 Dark/Light/System Theme Toggle (persisted)
- 🔍 Unified Universal Search with debounced API calls

## 🏗️ Architecture

This project follows Clean Architecture principles with pragmatic simplifications:

<p align="center">
  </br>
  <img width="80%" height="80%" src="https://github.com/piashcse/flutter-movie-clean-architecture/blob/main/screen_shots/flutter-clean-architecture.png" />
</p>

### Layers:
- **Presentation Layer**: UI components (pages/widgets), state management (Riverpod providers)
- **Domain Layer**: Business entities, repository interfaces
- **Data Layer**: Remote data sources (Dio), local persistence (Hive), repository implementations, data models

### Key Architectural Decisions:
- **No empty use case layer**: Use cases that only delegate to repositories were removed. Providers call repositories directly. Use cases are only added when they contain actual business logic.
- **Shared entities**: Duplicate `Cast`/`Crew` classes across features merged into `core/entities/credit_entity.dart`.
- **Shared widgets**: `MediaCard`, `DescriptionSection`, `RecommendationsSection`, `CreditsSection` reused across movie and TV series features.
- **Favorites as a proper feature**: Favorites provider and model moved from `core/hive/` and `movie/` into `features/favorites/` with proper Clean Architecture layers.

## 📁 Project Structure

```
flutter_movie_clean_architecture/
├── .env                                    # TMDB API key (gitignored)
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── config/
│   │   │   └── app_constant.dart           # URLs, reads apiKey from .env
│   │   ├── entities/
│   │   │   └── credit_entity.dart          # Shared Cast/Crew entities
│   │   ├── hive/
│   │   │   └── hive_helper.dart            # Hive initialization
│   │   ├── localization/
│   │   │   ├── app_localizations.dart
│   │   │   └── localization_helper.dart
│   │   ├── network/
│   │   │   └── dio_provider.dart           # Dio HTTP client
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── theme_providers.dart        # ThemeModeNotifier (direct Hive)
│   │   │   └── theme_toggle_widget.dart
│   │   ├── utils/
│   │   │   ├── pagination_consumer_state.dart  # Reusable pagination logic
│   │   │   └── utils.dart
│   │   └── widgets/
│   │       ├── media_card.dart             # Unified card for movie/tv/person
│   │       └── detail_sections.dart        # Shared Description/Recommendations/Credits
│   ├── routing/
│   │   └── app_router.dart
│   ├── presentation/
│   │   ├── pages/
│   │   │   └── main_tab_page.dart
│   │   └── widgets/
│   │       └── universal_search.dart       # Debounced universal search
│   └── features/
│       ├── celebrity/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   ├── models/
│       │   │   └── repositories/
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   └── repositories/
│       │   └── presentation/
│       │       ├── pages/
│       │       └── providers/
│       ├── favorites/                      # Proper Clean Architecture layers
│       │   ├── data/models/
│       │   │   ├── favorite_model.dart
│       │   │   └── favorite_model.g.dart
│       │   ├── presentation/providers/
│       │   │   └── favorite_provider.dart  # Single favorites StateNotifier
│       │   └── favorites_page.dart
│       ├── movie/
│       │   ├── data/
│       │   │   ├── datasources/
│       │   │   ├── models/
│       │   │   └── repositories/
│       │   ├── domain/
│       │   │   ├── entities/
│       │   │   └── repositories/
│       │   └── presentation/
│       │       ├── pages/
│       │       │   ├── movie_main_page.dart
│       │       │   ├── movie_detail_page.dart
│       │       │   ├── artist_detail_page.dart
│       │       │   ├── now_playing_page.dart    # Paginated
│       │       │   ├── popular_page.dart        # Paginated
│       │       │   ├── top_rated_page.dart
│       │       │   └── upcoming_movies_page.dart
│       │       └── providers/
│       │           └── movie_provider.dart
│       └── tv_series/
│           ├── data/
│           ├── domain/
│           └── presentation/
│               ├── pages/
│               └── providers/
├── test/
├── pubspec.yaml
├── analysis_options.yaml
├── .env
└── .gitignore
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.24.1 or higher)
- Dart SDK (3.8.0 or higher)
- Git
- TMDB API Key (free, register at https://www.themoviedb.org/settings/api)

### Installation

1. Clone the repository:
```bash
git clone git@github.com:piashcse/flutter-movie-clean-architecture.git
cd flutter-movie-clean-architecture
```

2. Set up environment variables:
```bash
# Edit .env and add your TMDB API key
TMDB_API_KEY=your_api_key_here
```

3. Install dependencies:
```bash
flutter pub get
```

4. Generate code (build runner):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

5. Run the app:
```bash
flutter run
```

## 🛠️ Built With

- [Flutter](https://flutter.dev) - Google's UI toolkit
- [Riverpod](https://riverpod.dev) - Composable state management
- [GoRouter](https://pub.dev/packages/go_router) - Declarative routing
- [Dio](https://pub.dev/packages/dio) - HTTP client
- [flutter_dotenv](https://pub.dev/packages/flutter_dotenv) - Environment variable management
- [JsonSerializable](https://pub.dev/packages/json_serializable) - JSON code generation
- [Flutter Localizations](https://flutter.dev/docs/development/accessibility-and-localization/internationalization) - Multi-language support
- [PrettyDioLogger](https://pub.dev/packages/pretty_dio_logger) - HTTP request logging
- [Hive](https://pub.dev/packages/hive) - Local key-value database
- [CachedNetworkImage](https://pub.dev/packages/cached_network_image) - Image caching

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
