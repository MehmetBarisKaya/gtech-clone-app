import 'package:flutter/material.dart';
//asfasfimport 'package:gtech/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:gtech/provider/user_provider.dart';
import 'package:gtech/screens/main_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            dividerTheme: const DividerThemeData(
              color: Colors.indigo,
              thickness: 0.1,
            ),
            primarySwatch: Colors.indigo,
            primaryColor: Colors.indigo),
        home: const MainScreen(),
      ),
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
    );
  }
}
