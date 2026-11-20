import 'package:flutter/material.dart';
import 'package:kids_mart/api/api_client.dart';
import 'package:kids_mart/api/shop_api.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/screens/auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _changeName(BuildContext context, AppStore store) async {
    final controller = TextEditingController(text: store.name);
    final name = await showDialog<String>(
      context: context,
      barrierDismissible: false,
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
    // Let the dialog and Android keyboard finish their removal animation before
    // releasing the controller that was attached to its text field.
    Future<void>.delayed(const Duration(milliseconds: 250), controller.dispose);
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
    final displayName = store.name.isEmpty ? 'Little Explorer' : store.name;
    final initial = displayName.characters.first.toUpperCase();
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 250,
            backgroundColor: canvas,
            surfaceTintColor: Colors.transparent,
            actions: [
              IconButton(
                tooltip: 'Refresh profile',
                icon: const Icon(Icons.refresh_rounded),
                onPressed: store.isSignedIn
                    ? () async {
                        await store.refreshProfile();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile refreshed')),
                          );
                        }
                      }
                    : null,
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(24, 0, 24, 18),
              title: const Text(
                'My Profile',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              background: DecoratedBox(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFE7F3FF), Color(0xFFFFF2DE)],
                  ),
                ),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 22, 24, 58),
                    child: Row(
                      children: [
                        Container(
                          width: 78,
                          height: 78,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 5),
                            boxShadow: [
                              BoxShadow(
                                color: blue.withValues(alpha: .18),
                                blurRadius: 16,
                                offset: const Offset(0, 7),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              initial,
                              style: const TextStyle(
                                color: blue,
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                displayName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: ink,
                                  fontSize: 23,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                store.email.isEmpty
                                    ? 'Your happy learning space'
                                    : store.email,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: muted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const _SectionLabel('ACCOUNT SETTINGS'),
                const SizedBox(height: 9),
                _SettingsCard(
                  children: [
                    _SettingsTile(
                      icon: Icons.person_outline_rounded,
                      color: blue,
                      title: 'Change name',
                      subtitle: store.isSignedIn
                          ? 'Update how we greet you'
                          : 'Sign in to update your account',
                      onTap: () => store.isSignedIn
                          ? _changeName(context, store)
                          : _signIn(context, store),
                    ),
                    const Divider(height: 1, indent: 68),
                    _SettingsTile(
                      icon: Icons.lock_outline_rounded,
                      color: const Color(0xFF9A71D6),
                      title: 'Change password',
                      subtitle: store.isSignedIn
                          ? 'Keep your account secure'
                          : 'Sign in to change your password',
                      onTap: () => store.isSignedIn
                          ? _changePassword(context, store)
                          : _signIn(context, store),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const _SectionLabel('ABOUT YOUR ACCOUNT'),
                const SizedBox(height: 9),
                _SettingsCard(
                  children: const [
                    _SettingsTile(
                      icon: Icons.verified_user_outlined,
                      color: Color(0xFF35A989),
                      title: 'Safe & private',
                      subtitle: 'Your saved details stay on this device',
                    ),
                  ],
                ),
                if (store.isSignedIn) ...[
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => _signOut(context, store),
                      icon: const Icon(Icons.logout_rounded),
                      label: const Text('Log out'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFD45454),
                        side: const BorderSide(color: Color(0xFFFFC8C8)),
                        minimumSize: const Size(0, 50),
                      ),
                    ),
                  ),
                ],
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _signIn(BuildContext context, AppStore store) async {
    final signedIn = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
    if (signedIn == true) await store.refreshProfile();
  }

  Future<void> _signOut(BuildContext context, AppStore store) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('You can sign in again anytime.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Log out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await store.signOut();
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('You have logged out')));
    }
  }

  Future<void> _changePassword(BuildContext context, AppStore store) async {
    final formKey = GlobalKey<FormState>();
    final current = TextEditingController();
    final next = TextEditingController();
    final confirm = TextEditingController();
    final submitted = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Change password'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: current,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Current password'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Enter your current password'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: next,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'New password'),
                validator: (value) => value == null || value.length < 8
                    ? 'Use at least 8 characters'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: confirm,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm new password'),
                validator: (value) => value != next.text
                    ? 'Passwords do not match'
                    : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (formKey.currentState!.validate()) Navigator.pop(context, true);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (submitted == true) {
      try {
        await ShopApi(accessToken: store.accessToken).changePassword(
          currentPassword: current.text,
          newPassword: next.text,
        );
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Password updated')),
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
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      current.dispose();
      next.dispose();
      confirm.dispose();
    });
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(left: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: muted,
        fontSize: 11,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.1,
      ),
    ),
  );
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: ink.withValues(alpha: .06),
          blurRadius: 18,
          offset: const Offset(0, 7),
        ),
      ],
    ),
    child: Column(children: children),
  );
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  const _SettingsTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) => ListTile(
    enabled: onTap != null,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
    leading: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color.withValues(alpha: .13),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Icon(icon, color: color),
    ),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    subtitle: Text(subtitle),
    trailing: const Icon(Icons.chevron_right_rounded),
    onTap: onTap,
  );
}
