import 'package:flutter/material.dart';
import 'package:kids_mart/api/api_client.dart';
import 'package:kids_mart/api/shop_api.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/data/app_store.dart';
import 'package:kids_mart/widgets/brand_logo.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _phone = TextEditingController();
  bool _registering = false;
  bool _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy || !_formKey.currentState!.validate()) return;
    setState(() => _busy = true);
    final store = AppScope.of(context);
    try {
      final api = ShopApi();
      if (_registering) {
        await api.register(
          name: _name.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
          phone: _phone.text.trim(),
        );
      }
      final response = await api.login(
        email: _email.text.trim(),
        password: _password.text,
      );
      final data = Map<String, dynamic>.from(
        (response as Map)['data'] as Map,
      );
      final user = Map<String, dynamic>.from(data['user'] as Map);
      await store.saveSession(
        name: user['name'] as String? ?? '',
        email: user['email'] as String? ?? _email.text.trim(),
        accessToken: data['token'] as String,
      );
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (error) {
      if (mounted) {
        final message = error.response is Map
            ? (error.response as Map)['message']?.toString()
            : null;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message ?? error.message)),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not sign in. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: canvas,
    body: DecoratedBox(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFDDEFFF), Color(0xFFF9FCFF), Color(0xFFFFF4E6)],
          stops: [0, .48, 1],
        ),
      ),
      child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton.filledTonal(
                  tooltip: 'Back',
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_rounded),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: BrandLogo(large: true)),
              const SizedBox(height: 28),
              Text(
                _registering ? 'Join the fun!' : 'Welcome back!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: ink,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _registering
                    ? 'Create an account to save your details and orders.'
                    : 'Sign in to manage your profile and place orders.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: muted, height: 1.45),
              ),
              const SizedBox(height: 28),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: .92),
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: ink.withValues(alpha: .09),
                      blurRadius: 26,
                      offset: const Offset(0, 12),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      if (_registering) ...[
                        _AuthField(
                          controller: _name,
                          icon: Icons.person_outline_rounded,
                          label: 'Your name',
                          capitalization: TextCapitalization.words,
                          validator: (value) => value == null || value.trim().isEmpty
                              ? 'Enter your name'
                              : null,
                        ),
                        const SizedBox(height: 14),
                      ],
                      _AuthField(
                        controller: _email,
                        icon: Icons.mail_outline_rounded,
                        label: 'Email address',
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => value == null ||
                                !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$')
                                    .hasMatch(value.trim())
                            ? 'Enter a valid email'
                            : null,
                      ),
                      const SizedBox(height: 14),
                      _AuthField(
                        controller: _password,
                        icon: Icons.lock_outline_rounded,
                        label: 'Password',
                        obscureText: true,
                        validator: (value) => value == null || value.length < 8
                            ? 'Use at least 8 characters'
                            : null,
                      ),
                      if (_registering) ...[
                        const SizedBox(height: 14),
                        _AuthField(
                          controller: _phone,
                          icon: Icons.phone_outlined,
                          label: 'Phone number (optional)',
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                      const SizedBox(height: 22),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: _busy ? null : _submit,
                          child: Text(
                            _busy
                                ? 'Please wait...'
                                : _registering
                                ? 'Create account'
                                : 'Sign in',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 14),
              TextButton(
                onPressed: _busy
                    ? null
                    : () => setState(() => _registering = !_registering),
                child: Text(
                  _registering
                      ? 'Already have an account? Sign in'
                      : 'New here? Create an account',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your information is kept safe and private.',
                textAlign: TextAlign.center,
                style: TextStyle(color: muted, fontSize: 12),
              ),
            ],
          ),
      ),
    ),
  );
}

class _AuthField extends StatelessWidget {
  final TextEditingController controller;
  final IconData icon;
  final String label;
  final TextInputType? keyboardType;
  final TextCapitalization capitalization;
  final bool obscureText;
  final String? Function(String?)? validator;
  const _AuthField({
    required this.controller,
    required this.icon,
    required this.label,
    this.keyboardType,
    this.capitalization = TextCapitalization.none,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller,
    keyboardType: keyboardType,
    textCapitalization: capitalization,
    obscureText: obscureText,
    validator: validator,
    decoration: InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      filled: true,
      fillColor: const Color(0xFFF7FAFE),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
