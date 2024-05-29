import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instaclone/provider/user_provider.dart';
import 'package:instaclone/responsiveness/mobile_screen_layout.dart';
import 'package:instaclone/responsiveness/responsive_layout.dart';
import 'package:instaclone/responsiveness/web_screen_layout.dart';
import 'package:instaclone/screens/login_screens.dart';
import 'package:instaclone/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyCoApFksirv-gMl-QTL3BlajW5YEKohu80",
            projectId: "cloneinsta-69c50",
            storageBucket: "cloneinsta-69c50.appspot.com",
            messagingSenderId: "888487594917",
            appId: "1:888487594917:web:2c8f68a3eec2f55ff1764c"));
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyA5phkYMBwSLiFeOhIllKAu5DwU6XCUsZQ",
          appId: "1:888487594917:android:06a7c814dc4f55bdf1764c",
          messagingSenderId: "737212678113",
          projectId: "cloneinsta-69c50",
          storageBucket: "cloneinsta-69c50.appspot.com"),
    );
  }

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'instagram clone with flutter',
        theme: ThemeData.dark()
            .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const ResponsiveLayout(
                  mobilescreenlayout: MobileScreenLayout(),
                  webscreenlayout: WebScreenLayout(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('${snapshot.error}'),
                );
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              );
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
/*const Scaffold(
        body: LoginScreen(),
        // body: ResponsiveLayout(
        //   mobilescreenlayout: MobileScreenLayout(),
        //   webscreenlayout: WebScreenLayout(),),*/