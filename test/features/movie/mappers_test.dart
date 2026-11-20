import 'package:flutter_movie_clean_architecture/core/entities/credit_entity.dart';
import 'package:flutter_movie_clean_architecture/core/models/credit_model.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/mappers.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/movie_detail_model.dart';
import 'package:flutter_movie_clean_architecture/features/movie/data/models/movie_model.dart';
import 'package:flutter_movie_clean_architecture/features/movie/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('movie mappers', () {
    test('maps a list of movie models', () {
      const models = [
        MovieModel(id: 1, title: 'Alien', posterPath: '/alien.jpg'),
        MovieModel(id: 2, title: 'Heat'),
      ];

      expect(models.toEntities(), const [
        Movie(id: 1, title: 'Alien', posterPath: '/alien.jpg'),
        Movie(id: 2, title: 'Heat'),
      ]);
    });

    test('maps detail fields and drops blank genres', () {
      const model = MovieDetailModel(
        id: 1,
        title: 'Alien',
        overview: 'In space...',
        runtime: 117,
        releaseDate: '1979-05-25',
        voteAverage: 8.1,
        genres: [
          Genre(id: 1, name: 'Horror'),
          Genre(id: 2),
        ],
        productionCompanies: [
          ProductionCompany(id: 1, name: 'Brandywine'),
          ProductionCompany(id: 2),
        ],
      );

      final entity = model.toEntity();

      expect(entity.id, 1);
      expect(entity.runtime, 117);
      expect(entity.genres, ['Horror']);
      expect(entity.productionCompanies, ['Brandywine']);
    });

    test('maps credits with cast and crew', () {
      const model = CreditModel(
        id: 1,
        cast: [CastModel(id: 2, name: 'Sigourney Weaver')],
        crew: [CrewModel(id: 3, name: 'Ridley Scott', job: 'Director')],
      );

      final entity = model.toEntity();

      expect(entity, isA<CreditEntity>());
      expect(entity.cast.single.name, 'Sigourney Weaver');
      expect(entity.crew.single.job, 'Director');
    });
  });
}
