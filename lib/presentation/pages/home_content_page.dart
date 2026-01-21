import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eyadflix/presentation/providers/app_providers.dart';
import 'package:eyadflix/presentation/pages/addon_detail_page.dart';

class HomeContentPage extends ConsumerWidget {
  const HomeContentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installedAddons = ref.watch(installedAddonsProvider);
    final enabledAddons = ref.watch(installedAddonsProvider).where((a) => a.isEnabled).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('homeScreen.title'.tr()),
        elevation: 0,
      ),
      body: enabledAddons.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.extension_outlined,
                    size: 80,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'homeScreen.noAddons'.tr(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: enabledAddons.length,
              itemBuilder: (context, index) {
                final addon = enabledAddons[index];
                return ListTile(
                  leading: addon.logo != null
                      ? Image.network(
                          addon.logo!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.extension),
                  title: Text(addon.name),
                  subtitle: Text(addon.manifestUrl),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddonDetailPage(addon: addon),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}
