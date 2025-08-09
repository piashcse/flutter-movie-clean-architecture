import 'package:flutter/material.dart';
import 'package:flutter_movie_clean_architecture/core/config/app_constant.dart';
import 'package:flutter_movie_clean_architecture/features/movie/presentation/providers/movie_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtistDetailPage extends ConsumerStatefulWidget {
  final int artistId;

  const ArtistDetailPage({super.key, required this.artistId});

  @override
  ConsumerState<ArtistDetailPage> createState() => _ArtistDetailPageState();
}

class _ArtistDetailPageState extends ConsumerState<ArtistDetailPage> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final artistDetailAsync = ref.watch(artistDetailProvider(widget.artistId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: artistDetailAsync.when(
        data: (artist) => CustomScrollView(
          slivers: [
            // Silver AppBar
            SliverAppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              pinned: true,
              floating: false,
              expandedHeight: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () =>{
                  Navigator.pop(context)
                },
              ),
              title: Text(
                artist.name,
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Artist Profile Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: artist.profilePath != null
                                ? DecorationImage(
                              image: NetworkImage("$IMAGE_URL${artist.profilePath}"),
                              fit: BoxFit.cover,
                            )
                                : null,
                            color: artist.profilePath == null
                                ? Colors.grey[300]
                                : null,
                          ),
                          child: artist.profilePath == null
                              ? const Icon(Icons.person,
                              color: Colors.grey, size: 60)
                              : null,
                        ),
                        const SizedBox(width: 18),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                artist.name,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Artist Detail',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                artist.knownForDepartment ?? 'Acting',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Artist Detail Info
                              Text(
                                'Artist Detail',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const Text(
                                '1',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Birthday
                              Text(
                                'Birthday',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                artist.birthday ?? '1978-10-13',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Place of Birth
                              Text(
                                'Place of Birth',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              Text(
                                artist.placeOfBirth ?? 'Orange County, California, USA',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Biography Section
                    const Text(
                      'Biography',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      artist.biography ??
                          "Sadie Katz is a working actress living in Los Angeles. Her most recent film Credits include starring in 20th Century Fox's Fan Favorite Horror franchise \"Wrong Turn 6\" playing the twisted, sexy Sally Hillicker. Showing her range and acting chops she also played the sweet sensitive, leading lady in \"Chavez: Cage of Glory\" opening in 400 theaters September 2013 along side Danny Trejo, Steven Bauer and Hector Echavarria. Katz also stars in the thriller \"House of Bad\" Fan Favorite Award Winner at Big Bear Horror Fest 2013. You can also see Sadie starring as a free-spirited partygirl with issues in \"Nipple and Pal...",
                      maxLines: _isExpanded ? null : 4,
                      overflow: _isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isExpanded = !_isExpanded;
                        });
                      },
                      child: Text(
                        _isExpanded ? 'Show less' : 'Show more',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.cyan,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFF7B2CBF)),
        ),
        error: (error, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading artist details',
                  style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              Text(error.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}