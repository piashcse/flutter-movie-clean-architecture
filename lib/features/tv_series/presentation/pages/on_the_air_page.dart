import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/utils/pagination_consumer_state.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/providers/tv_series_provider.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OnTheAirPage extends ConsumerStatefulWidget {
  const OnTheAirPage({super.key});

  @override
  ConsumerState<OnTheAirPage> createState() => _OnTheAirPageState();
}

class _OnTheAirPageState
    extends PaginationConsumerState<TvSeries, OnTheAirPage> {
  @override
  Future<List<TvSeries>> fetchData(int page) async {
    return ref.read(onTheAirTvSeriesProvider(page).future);
  }

  @override
  Widget build(BuildContext context) {
    return buildContent(
      context: context,
      itemBuilder: (tvSeries) => TvSeriesCardWidget(tvSeries: tvSeries),
    );
  }
}
