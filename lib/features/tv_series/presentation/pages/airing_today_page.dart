import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/utils/pagination_consumer_state.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/domain/entities/tv_series.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/providers/tv_series_provider.dart';
import 'package:flutter_movie_clean_architecture/features/tv_series/presentation/widgets/tv_series_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AiringTodayPage extends ConsumerStatefulWidget {
  const AiringTodayPage({super.key});

  @override
  ConsumerState<AiringTodayPage> createState() => _AiringTodayPageState();
}

class _AiringTodayPageState extends PaginationConsumerState<TvSeries, AiringTodayPage> {
  @override
  Future<List<TvSeries>> fetchData(int page) async {
    return ref.read(airingTodayTvSeriesProvider(page).future);
  }

  @override
  Widget build(BuildContext context) {
    return buildContent(
      context: context,
      itemBuilder: (tvSeries) => TvSeriesCardWidget(tvSeries: tvSeries),
    );
  }
}