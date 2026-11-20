/// Centralised route paths and builders.
///
/// Using helpers instead of string interpolation keeps navigation type-safe and
/// makes a future rename a one-line change.
abstract final class AppRoutes {
  static const String home = '/';

  static const String homeName = 'home';
  static const String movieName = 'movie';
  static const String tvName = 'tv';
  static const String artistName = 'artist';

  static const String moviePattern = '/movie/:id';
  static const String tvPattern = '/tv/:id';
  static const String artistPattern = '/artist/:id';

  static const String idParam = 'id';

  static String movie(int id) => '/movie/$id';

  static String tv(int id) => '/tv/$id';

  static String artist(int id) => '/artist/$id';
}
