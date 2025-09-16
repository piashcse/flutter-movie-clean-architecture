import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/domain/entities/person.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/providers/celebrity_provider.dart';
import 'package:flutter_movie_clean_architecture/features/celebrity/presentation/widgets/person_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CelebritySearchPage extends ConsumerStatefulWidget {
  final String query;

  const CelebritySearchPage({super.key, required this.query});

  @override
  ConsumerState<CelebritySearchPage> createState() => _CelebritySearchPageState();
}

class _CelebritySearchPageState extends ConsumerState<CelebritySearchPage> {
  final _scrollController = ScrollController();
  int _currentPage = 1;
  final List<Person> _persons = [];
  bool _isLoadingMore = false;
  bool _hasMore = true;
  bool _isInitialLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPage(_currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !_isLoadingMore &&
          _hasMore) {
        _loadPage(++_currentPage);
      }
    });
  }

  Future<void> _loadPage(int page) async {
    setState(() {
      _isLoadingMore = true;
    });

    final result = await ref.read(searchPersonsPaginatedProvider((widget.query, page)).future);

    setState(() {
      if (result.isNotEmpty) {
        _persons.addAll(result);
      } else {
        _hasMore = false;
      }
      _isLoadingMore = false;
      _isInitialLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "${widget.query}"'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _isInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(8),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 2 / 3,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _persons.length + (_hasMore && _isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _persons.length) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return PersonCardWidget(person: _persons[index]);
                    },
                  ),
                ),
                if (_hasMore && _isLoadingMore && !_isInitialLoading)
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24.0, top: 8.0),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}