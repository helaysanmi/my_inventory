import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_inventory/features/authentication/login/login_screen.dart';
import 'package:my_inventory/features/onboarding/screens/onboarding.dart';
import 'package:my_inventory/utils/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class App extends StatelessWidget {
//   const App({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       themeMode: ThemeMode.system,
//       theme: TAppTheme.lightTheme,
//       darkTheme: TAppTheme.darkTheme,
//       debugShowCheckedModeBanner: false,
//       home: const OnBoardingScreen(),
//     );
//   }
// }

class App extends StatelessWidget {
  const App({super.key});

  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        return GetMaterialApp(
          themeMode: ThemeMode.system,
          theme: TAppTheme.lightTheme,
          darkTheme: TAppTheme.darkTheme,
          debugShowCheckedModeBanner: false,
          home: _buildHome(snapshot),
        );
      },
    );
  }

  Widget _buildHome(AsyncSnapshot<bool> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (snapshot.hasError) {
      return const Scaffold(body: Center(child: Text('Error loading app')));
    } else {
      final isLoggedIn = snapshot.data ?? false;

      if (isLoggedIn) {
        return const LoginScreen();
      } else {
        return const OnBoardingScreen();
      }
    }
  }
}
