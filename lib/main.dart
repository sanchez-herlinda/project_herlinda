import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'services/auth_service.dart';
import 'screens/login_screen.dart';
import 'screens/personal_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyAsh1Zrmpjr67rr3h8GpGiuJ6oO6M7q7Qs",
        authDomain: "bdcrudrestaurante.firebaseapp.com",
        projectId: "bdcrudrestaurante",
        storageBucket: "bdcrudrestaurante.firebasestorage.app",
        messagingSenderId: "1008385277046",
        appId: "1:1008385277046:web:d0ebfd0ec41e327b88b357",
      ),
    );
  } else {
    // Android usa el archivo google-services.json automáticamente
    await Firebase.initializeApp();
  }

  runApp(const LaRomaApp());
}

class LaRomaApp extends StatelessWidget {
  const LaRomaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF3E2723),
      ),
      home: StreamBuilder<User?>(
        stream: AuthService().user,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          if (snapshot.hasData) return PersonalScreen();
          return LoginScreen();
        },
      ),
    );
  }
}
