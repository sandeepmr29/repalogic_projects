import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'l10n/app_localizations_delegate.dart';
import 'screens/home_screen.dart';
import 'models/user_model.dart';
import 'services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await LocalStorageService.init();

  // Example users
  final user1 = UserModel(uid: 'user1', name: 'Mathew');
  final user2 = UserModel(uid: 'user2', name: 'Tom');
  final user3 = UserModel(uid: 'user3', name: 'John');
  final user4 = UserModel(uid: 'user4', name: 'Christy');
  runApp(MyApp(users: [user1, user2, user3, user4]));
}

class MyApp extends StatelessWidget {
  final List<UserModel> users;

  const MyApp({super.key, required this.users});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('en'),
      // 🔁 change dynamically
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: HomeScreen(users: users),
    );
  }
}
