import 'package:flutter/material.dart';
import 'package:podcast_app/providers/podcast_lists_provider.dart';
import 'package:podcast_app/screens/library_detail_screen.dart';
import 'package:podcast_app/utils/constants.dart';
import '../providers/categories_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/category.dart';
import './search_results_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {

  final searchController = TextEditingController();
  int searchControllerTextLength = 0;

  @override
  void initState() {
    super.initState();
    ref.read(categoriesProvider.notifier).fetchCategories();
    searchController.addListener(() {
      ref.read(podcastListsProvider.notifier).searchPodcastLists(searchController.text);
      setState(() {
        searchControllerTextLength = searchController.text.trim().length;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    


    final List<Category> categories = ref.watch(categoriesProvider);
    final podcastLists = ref.watch(podcastListsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search_rounded),
                label: const Text('Search'),
                hintText: 'Type something here',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0)
                )
              ),
            ),
            const SizedBox(height: 20,),
            Expanded(
              child: searchControllerTextLength > 0 ? ListView.builder(
                itemCount: podcastLists.length,
                itemBuilder: (ctx, i) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => LibraryDetailScreen(podcastList: podcastLists[i], isFollowing: false,)
                        )
                      );
                    },
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                          child: Image(
                            width: double.infinity,
                            height: 200,
                            image: CachedNetworkImageProvider('${Constants.S3_BUCKET_URL}/${podcastLists[i].imageUrl}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          bottom: 0,
                          left: 0,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(12.0)
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                podcastLists[i].title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18
                                ),
                              ),
                              Text(
                                podcastLists[i].description,
                                style: const TextStyle(
                                  color: Colors.grey
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ) : GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                children: List.generate(categories.length, (i) => InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const SearchResultsScreen()
                      )
                    );
                  },
                  splashColor: Colors.grey.withOpacity(0.5),
                  highlightColor: Colors.blue.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12.0),
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12.0)
                    ),
                    child: Center(
                      child: Text(
                        categories[i].name,
                        style: const TextStyle(
                            color: Colors.black
                        ),
                      ),
                    ),
                  ),
                )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}