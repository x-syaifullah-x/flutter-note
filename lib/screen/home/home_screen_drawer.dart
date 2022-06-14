import 'package:flutter/material.dart';

import '../../data/user/user_repository.dart';
import '../sign/sign_in_screen.dart';

class DrawerHome extends StatelessWidget {
  const DrawerHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DrawerHeader(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.lightBlue, Colors.white],
                            ),
                          ),
                        ),
                      ),
                      const Text("Profile", style: TextStyle(fontSize: 20)),
                      const Text("List", style: TextStyle(fontSize: 20)),
                      const Text("Gird", style: TextStyle(fontSize: 20)),
                    ],
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        UserRepository.getInstance()
                            .signOut()
                            .then((isSuccess) {
                          if (isSuccess) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (builder) => const SignInScreen(),
                              ),
                              (route) => false,
                            );
                          }
                        });
                      },
                      child: const Text("Sign Out"),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
