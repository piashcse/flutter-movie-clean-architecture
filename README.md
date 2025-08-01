# Flutter Movie
[![Flutter](https://img.shields.io/badge/Flutter-3.22.1-blue.svg?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3.1-blue.svg?logo=dart)](https://dart.dev)
[![Riverpod](https://img.shields.io/badge/Riverpod-2.5.1-brightgreen?logo=flutter)](https://riverpod.dev)
![badge-Android](https://img.shields.io/badge/Platform-Android-brightgreen)
![badge-iOS](https://img.shields.io/badge/Platform-iOS-lightgray)
[![GitHub license](https://img.shields.io/badge/license-Apache%20License%202.0-blue.svg?style=flat)](https://www.apache.org/licenses/LICENSE-2.0)
<a href="https://github.com/piashcse"><img alt="GitHub" src="https://img.shields.io/static/v1?label=GitHub&message=piashcse&color=C51162"/></a>

Flutter Movie is built with Riverpod, Clean Architecture, and GoRouter that showcases movies fetched from TMDB API. It includes now playing, popular, top-rated, and upcoming movies with support for pagination, search, and detailed view.
<p align="center">
  <img width="35%" src="https://github.com/piashcse/flutter-movie-clean-architecture/blob/main/screen_shots/Simulator%20Screenshot-iphone-16-pro-2025-08-01-15.08.32.png" />
  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
  <img width="35%" src="https://github.com/piashcse/flutter-movie-clean-architecture/blob/main/screen_shots/Simulator%20Screenshot-iphone-16-pro-2025-08-01-15.08.38.png" />
</p>


# ✨ Features
-	🎞 Now Playing, Popular, Top Rated & Upcoming movie sections
-	🔍 Movie Detail Page
-	📃 Pagination (infinite scroll)
-	🔄 Bottom Navigation
-	🧭 Declarative Routing with GoRouter
-	🧱 Clean Architecture (Presentation / Domain / Data)
-	🧪 Riverpod State Management
-	🌐 Network layer using Dio with Logging
-	🚀 Smooth UX with loading indicators

## Architecture

<p align="center">
  </br>
  <img width="80%" height="80%" src="https://github.com/piashcse/flutter-movie-clean-architecture/blob/main/screen_shots/flutter-clean-architecture.png" />
</p>
<p align="center">
<b>Fig.  Clean Architecture </b>
</p>

## Project Directory

```
flutter_movie_clean_architecture/
├── lib/
│   ├── core/
│   │   ├── config/
│   │   │   └── app_constant.dart
│   │   ├── network/
│   │   │   └── dio_provider.dart
│   │   └── utils/
│   ├── features/
│   │   └── movie/
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── movie_remote_data_source.dart
│   │       │   ├── models/
│   │       │   │   ├── movie_model.dart
│   │       │   │   ├── movie_model.freezed.dart
│   │       │   │   └── movie_model.g.dart
│   │       │   └── repositories/
│   │       │       └── movie_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── movie.dart
│   │       │   ├── repositories/
│   │       │   │   └── movie_repository.dart
│   │       │   └── usecases/
│   │       │       ├── get_now_playing.dart
│   │       │       ├── get_popular.dart
│   │       │       ├── get_top_rated.dart
│   │       │       └── get_up_coming.dart
│   │       └── presentation/
│   │           ├── pages/
│   │           │   ├── movie_detail_page.dart
│   │           │   ├── movie_main_page.dart
│   │           │   ├── now_playing_page.dart
│   │           │   ├── popular_page.dart
│   │           │   ├── top_rated_page.dart
│   │           │   └── up_coming_page.dart
│   │           ├── providers/
│   │           │   └── movie_provider.dart
│   │           └── widgets/
│   │               └── movie_card.dart
│   ├── routing/
│   │   ├── app_router.dart
│   │   └── main.dart
│   └── main.dart
├── ios/
├── screen_shots/
├── test/
├── .flutter-plugins
├── .flutter-plugins-dependencies
├── .gitignore
├── .metadata
├── analysis_options.yaml
└── flutter_movie_clean_architecture.iml
```

## Clone the repository

```bash
git clone git@github.com:piashcse/flutter-movie-clean-architecture.git
```

## Install dependencies

```bash
flutter pub get
```

## Run the app

```bash
flutter run
```


## Built With 🛠
- [Flutter](https://flutter.dev) - Google’s UI toolkit for building natively compiled applications for mobile, web, and desktop from a single codebase.
- [Riverpod](https://riverpod.dev) - A simple, composable, and testable state management solution for Flutter.
- [GoRouter](https://pub.dev/packages/go_router) - Declarative routing package for Flutter, designed to work seamlessly with state management and deep linking.
- [Dio](https://pub.dev/packages/dio) - A powerful HTTP client for Dart, supporting interceptors, global configuration, FormData, request cancellation, and more.
- [Freezed](https://pub.dev/packages/freezed) - A code generator for immutable classes that helps with union types/pattern matching in Dart.
- [JsonSerializable](https://pub.dev/packages/json_serializable) - Generates code for converting between Dart objects and JSON, making serialization easy.
- [Logger / DioLogger](https://pub.dev/packages/logger) - Easy and pretty logging package for debugging; use `DioLogger` to log Dio HTTP requests and responses.

## 👨 Developed By

<a href="https://twitter.com/piashcse" target="_blank">
  <img src="https://avatars.githubusercontent.com/piashcse" width="80" align="left">
</a>

**Mehedi Hassan Piash**

[![Twitter](https://img.shields.io/badge/-Twitter-1DA1F2?logo=x&logoColor=white&style=for-the-badge)](https://twitter.com/piashcse)
[![Medium](https://img.shields.io/badge/-Medium-00AB6C?logo=medium&logoColor=white&style=for-the-badge)](https://medium.com/@piashcse)
[![Linkedin](https://img.shields.io/badge/-LinkedIn-0077B5?logo=linkedin&logoColor=white&style=for-the-badge)](https://www.linkedin.com/in/piashcse/)
[![Web](https://img.shields.io/badge/-Web-0073E6?logo=appveyor&logoColor=white&style=for-the-badge)](https://piashcse.github.io/)
[![Blog](https://img.shields.io/badge/-Blog-0077B5?logo=readme&logoColor=white&style=for-the-badge)](https://piashcse.blogspot.com)

# License
```
Copyright 2024 piashcse (Mehedi Hassan Piash)

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
