import 'package:flutter/material.dart';
import 'package:kids_mart/constants/colors.dart';
import 'package:kids_mart/screens/splash_screen.dart';
import 'package:kids_mart/data/app_store.dart';

void main() => runApp(const _Startup());

class _Startup extends StatefulWidget {
  const _Startup();
  @override
  State<_Startup> createState() => _StartupState();
}

class _StartupState extends State<_Startup> {
  late Future<AppStore> _load = AppStore.open();
  @override
  Widget build(BuildContext context) => FutureBuilder<AppStore>(
    future: _load,
    builder: (context, snapshot) {
      if (snapshot.hasData) return KidsMartApp(store: snapshot.data!);
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: snapshot.hasError
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Could not load your saved data.'),
                      TextButton(
                        onPressed: () =>
                            setState(() => _load = AppStore.open()),
                        child: const Text('Retry'),
                      ),
                    ],
                  )
                : const CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
}

class KidsMartApp extends StatelessWidget {
  final AppStore? store;
  const KidsMartApp({super.key, this.store});

  @override
  Widget build(BuildContext context) {
    return AppScope(
      store: store ?? AppStore(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Kids Mart',
        theme: ThemeData(
          useMaterial3: true,
          scaffoldBackgroundColor: canvas,
          colorScheme: ColorScheme.fromSeed(seedColor: blue, primary: blue),
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            backgroundColor: canvas,
            surfaceTintColor: Colors.transparent,
            foregroundColor: ink,
            centerTitle: true,
            elevation: 0,
          ),
          filledButtonTheme: FilledButtonThemeData(
            style: FilledButton.styleFrom(
              minimumSize: const Size(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
