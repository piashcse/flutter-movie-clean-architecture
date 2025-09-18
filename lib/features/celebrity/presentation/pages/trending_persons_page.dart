import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/utils/pagination_consumer_state.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/providers/celebrity_provider.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/widgets/person_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrendingPersonsPage extends ConsumerStatefulWidget {
  const TrendingPersonsPage({super.key});

  @override
  ConsumerState<TrendingPersonsPage> createState() => _TrendingPersonsPageState();
}

class _TrendingPersonsPageState extends PaginationConsumerState<Person, TrendingPersonsPage> {
  @override
  Future<List<Person>> fetchData(int page) async {
    return ref.read(trendingPersonsProvider(page).future);
  }

  @override
  Widget build(BuildContext context) {
    return buildContent(
      context: context,
      itemBuilder: (person) => PersonCardWidget(person: person),
    );
  }
}