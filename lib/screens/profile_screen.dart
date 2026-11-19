import 'package:flutter/material.dart';
import 'package:kids_mart/api/api_client.dart';
import 'package:kids_mart/api/shop_api.dart';
import 'package:kids_mart/data/app_store.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _changeName(BuildContext context, AppStore store) async {
    final controller = TextEditingController(text: store.name);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change name'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Your name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.isEmpty || !context.mounted) return;
    try {
      await ShopApi(accessToken: store.accessToken).updateProfile(name: name);
      await store.saveSession(
        name: name,
        email: store.email,
        accessToken: store.accessToken,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Name updated')),
        );
      }
    } on ApiException catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error.message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = AppScope.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            store.name.isEmpty ? 'My account' : store.name,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          if (store.email.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(store.email),
          ],
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.person_outline_rounded),
            title: const Text('Change name'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: store.isSignedIn ? () => _changeName(context, store) : null,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.lock_outline_rounded),
            title: const Text('Change password'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Password changes'),
                content: const Text(
                  'The current API does not provide a password-change endpoint yet.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
