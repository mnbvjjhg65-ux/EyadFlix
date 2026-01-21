import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eyadflix/presentation/providers/app_providers.dart';
import 'package:eyadflix/services/addon_service.dart';
import 'package:eyadflix/data/models/installed_addon.dart';
import 'package:eyadflix/core/constants/app_constants.dart';

class AddonsPage extends ConsumerStatefulWidget {
  const AddonsPage({Key? key}) : super(key: key);

  @override
  ConsumerState<AddonsPage> createState() => _AddonsPageState();
}

class _AddonsPageState extends ConsumerState<AddonsPage> {
  final _urlController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _installAddon() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('validation.emptyField'.tr())),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final addonService = ref.read(addonServiceProvider);
      final manifestUrl = url.endsWith('/manifest.json') ? url : '$url/manifest.json';
      
      final manifest = await addonService.fetchManifest(manifestUrl);
      
      final addon = InstalledAddon(
        id: manifest.id,
        manifestUrl: AddonService.normalizeAddonUrl(url),
        name: manifest.name,
        logo: manifest.logo,
        installedAt: DateTime.now(),
        version: manifest.version,
      );

      await ref.read(installedAddonsProvider.notifier).addAddon(addon);
      
      _urlController.clear();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('addonsScreen.successfullyInstalled'.tr())),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('addonsScreen.failedToFetch'.tr())),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final addons = ref.watch(installedAddonsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('addonsScreen.title'.tr()),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'addonsScreen.addNew'.tr(),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _urlController,
                        decoration: InputDecoration(
                          hintText: 'addonsScreen.pasteUrl'.tr(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.link),
                        ),
                        enabled: !_isLoading,
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: _isLoading ? null : _installAddon,
                        child: Text(
                          _isLoading
                              ? 'addonsScreen.installing'.tr()
                              : 'addonsScreen.install'.tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'addonsScreen.installedAddons'.tr(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 12),
              if (addons.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'addonsScreen.noAddons'.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: addons.length,
                  itemBuilder: (context, index) {
                    final addon = addons[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: addon.logo != null
                            ? Image.network(
                                addon.logo!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.extension),
                        title: Text(addon.name),
                        subtitle: Text(
                          addon.manifestUrl,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                addon.isEnabled
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () {
                                ref
                                    .read(installedAddonsProvider.notifier)
                                    .toggleAddonStatus(addon.id);
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('addonsScreen.removeAddon'.tr()),
                                    content:
                                        Text('addonsScreen.confirmDelete'.tr()),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context),
                                        child: Text('cancel'.tr()),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ref
                                              .read(installedAddonsProvider
                                                  .notifier)
                                              .removeAddon(addon.id);
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'delete'.tr(),
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
