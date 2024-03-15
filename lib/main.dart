import 'package:flutter/material.dart';
import 'user/LoginScreen.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
   ErrorWidget.builder = (FlutterErrorDetails details) => const Scaffold(
    body: Center(
      child: Text('')
    ),
  );
  await dotenv.load(fileName: "assets/.env"  );
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const UserLoginScreen(),
    );
  }
}
