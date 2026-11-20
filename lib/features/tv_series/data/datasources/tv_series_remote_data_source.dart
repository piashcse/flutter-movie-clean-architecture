import 'package:flutter_movie_clean_architecture/core/models/credit_model.dart';
import 'package:flutter_movie_clean_architecture/core/network/tmdb_client.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/tv_series_detail_model.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/data/models/tv_series_model.dart';

abstract interface class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getAiringToday(int page);

  Future<List<TvSeriesModel>> getOnTheAir(int page);

  Future<List<TvSeriesModel>> getPopular(int page);

  Future<List<TvSeriesModel>> getUpcoming(int page);

  Future<TvSeriesDetailModel> getDetail(int tvSeriesId);

  Future<List<TvSeriesModel>> search(String query);

  Future<List<TvSeriesModel>> getRecommended(int tvSeriesId);

  Future<CreditModel> getCredits(int tvSeriesId);
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  const TvSeriesRemoteDataSourceImpl(this._client);

  final TmdbClient _client;

  static const _pageKey = 'page';

  @override
  Future<List<TvSeriesModel>> getAiringToday(int page) => _client.getList(
    'tv/airing_today',
    TvSeriesModel.fromJson,
    query: {_pageKey: page},
  );

  @override
  Future<List<TvSeriesModel>> getOnTheAir(int page) => _client.getList(
    'tv/on_the_air',
    TvSeriesModel.fromJson,
    query: {_pageKey: page},
  );

  @override
  Future<List<TvSeriesModel>> getPopular(int page) => _client.getList(
    'tv/popular',
    TvSeriesModel.fromJson,
    query: {_pageKey: page},
  );

  @override
  Future<List<TvSeriesModel>> getUpcoming(int page) => _client.getList(
    'tv/upcoming',
    TvSeriesModel.fromJson,
    query: {_pageKey: page},
  );

  @override
  Future<TvSeriesDetailModel> getDetail(int tvSeriesId) async =>
      TvSeriesDetailModel.fromJson(await _client.getObject('tv/$tvSeriesId'));

  @override
  Future<List<TvSeriesModel>> search(String query) => _client.getList(
    'search/tv',
    TvSeriesModel.fromJson,
    query: {'query': query},
  );

  @override
  Future<List<TvSeriesModel>> getRecommended(int tvSeriesId) =>
      _client.getList('tv/$tvSeriesId/recommendations', TvSeriesModel.fromJson);

  @override
  Future<CreditModel> getCredits(int tvSeriesId) async =>
      CreditModel.fromJson(await _client.getObject('tv/$tvSeriesId/credits'));
}
