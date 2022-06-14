import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lorem/flutter_lorem.dart';
import 'package:submission_bmafup/screen/sign/sign_up_screen.dart';

import '../../utils/utils.dart';
import '../sign/sign_in_screen.dart';

class StartedScreen extends StatelessWidget {
  const StartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          body: _Body(),
        ),
        onWillPop: () {
          SystemNavigator.pop(animated: true);
          return Future.value(true);
        });
  }
}

class _Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.lightBlue, Colors.white],
        ),
      ),
      child: CustomScrollView(
        scrollDirection: Axis.vertical,
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _imageNote(),
                const SizedBox(height: 50),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _getStartedText(),
                          const SizedBox(height: 8),
                          _getStartedTextSub(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 50),
                    _createAccountButton(context),
                    _alreadyAccountText(context),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getStartedTextSub() => Text(
        lorem(paragraphs: 1, words: 30),
        style: const TextStyle(fontSize: 16),
      );

  Widget _getStartedText() => const Text(
        'Let\'s Get Started',
        style: TextStyle(
          fontSize: 35,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _alreadyAccountText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 6, bottom: 20),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Already have an account?",
          style: const TextStyle(
            color: Colors.black,
            fontSize: 12,
          ),
          children: [
            TextSpan(
              text: " Login",
              style: const TextStyle(color: Colors.blueAccent),
              recognizer: TapGestureRecognizer()
                ..onTap = () => Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (builder) => const SignInScreen(),
                      ),
                      (route) => false,
                    ),
            )
          ],
        ),
      ),
    );
  }

  Widget _createAccountButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          fixedSize: Size(getWidthDevice(context, 75), 40),
        ),
        child: const Text(
          "CREATE ACCOUNT",
          textAlign: TextAlign.center,
        ),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (builder) => const SignUpScreen(),
            ),
            (route) => false,
          );
        },
      ),
    );
  }

  Widget _imageNote() {
    return Center(
      child: Container(
        padding: const EdgeInsets.only(top: 100),
        child: Image.asset(
          "assets/images/notes.svg",
          width: 200,
          height: 150,
        ),
      ),
    );
  }
}
