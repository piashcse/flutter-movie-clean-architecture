import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/utils/pagination_consumer_state.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/providers/tv_series_provider.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularTvSeriesPage extends ConsumerStatefulWidget {
  const PopularTvSeriesPage({super.key});

  @override
  ConsumerState<PopularTvSeriesPage> createState() =>
      _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState
    extends PaginationConsumerState<TvSeries, PopularTvSeriesPage> {
  @override
  Future<List<TvSeries>> fetchData(int page) async {
    return ref.read(popularTvSeriesProvider(page).future);
  }

  @override
  Widget build(BuildContext context) {
    return buildContent(
      context: context,
      itemBuilder: (tvSeries) => TvSeriesCardWidget(tvSeries: tvSeries),
    );
  }
}
