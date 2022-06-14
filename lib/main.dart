import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:submission_bmafup/data/user/user_repository.dart';
import 'package:submission_bmafup/data/user/user.dart';
import 'package:submission_bmafup/screen/home/home_screen.dart';
import 'package:submission_bmafup/screen/started/started_screen.dart';

Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  User? currentUser = await UserRepository.getInstance().getCurrentUser();

  Widget widget;

  if (currentUser != null) {
    widget = HomeScreen(currentUser);
  } else {
    widget = const StartedScreen();
  }

  runApp(
    MaterialApp(
      home: widget,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.black,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
        ),
      ),
    ),
  );
}
