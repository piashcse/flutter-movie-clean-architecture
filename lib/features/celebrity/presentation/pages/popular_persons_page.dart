import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/utils/pagination_consumer_state.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/providers/celebrity_provider.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/widgets/person_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PopularPersonsPage extends ConsumerStatefulWidget {
  const PopularPersonsPage({super.key});

  @override
  ConsumerState<PopularPersonsPage> createState() => _PopularPersonsPageState();
}

class _PopularPersonsPageState
    extends PaginationConsumerState<Person, PopularPersonsPage> {
  @override
  Future<List<Person>> fetchData(int page) async {
    return ref.read(popularPersonsProvider(page).future);
  }

  @override
  Widget build(BuildContext context) {
    return buildContent(
      context: context,
      itemBuilder: (person) => PersonCardWidget(person: person),
    );
  }
}
