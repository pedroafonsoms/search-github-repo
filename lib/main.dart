import 'package:flutter/material.dart';
import 'package:search_github_repo/views/repository_search_screen.dart';

import 'views/repository_list_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  /*
   * 5. Refactor cada classse
   */
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.indigo)
            .copyWith(secondary: Colors.deepPurple),
      ),
      // home: RepositorySearchScreen(),
      routes: {
        '/': (context) => const RepositorySearchScreen(),
        '/account-details': (context) => const RepositoryListScreen(),
      },
    );
  }
}
