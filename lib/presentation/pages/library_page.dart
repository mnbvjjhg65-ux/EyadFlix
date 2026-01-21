import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eyadflix/presentation/providers/library_providers.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesProvider);
    final watchHistory = ref.watch(watchHistoryProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('libraryScreen.title'.tr()),
          elevation: 0,
          bottom: TabBar(
            tabs: [
              Tab(text: 'libraryScreen.favorites'.tr()),
              Tab(text: 'libraryScreen.watchHistory'.tr()),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Favorites Tab
            favorites.isEmpty
                ? Center(
                    child: Text('libraryScreen.noFavorites'.tr()),
                  )
                : ListView.builder(
                    itemCount: favorites.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(favorites[index]),
                      );
                    },
                  ),
            // Watch History Tab
            watchHistory.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.history,
                          size: 80,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.5),
                        ),
                        const SizedBox(height: 16),
                        Text('libraryScreen.noHistory'.tr()),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: watchHistory.length,
                    itemBuilder: (context, index) {
                      final item = watchHistory[index];
                      return ListTile(
                        leading: item.poster != null
                            ? Image.network(
                                item.poster!,
                                width: 50,
                                height: 75,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.movie),
                        title: Text(item.mediaName),
                        subtitle: Text(
                          '${item.watchProgress.toStringAsFixed(1)}% watched',
                        ),
                        trailing: Text(
                          '${item.lastWatchedAt.day}/${item.lastWatchedAt.month}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
