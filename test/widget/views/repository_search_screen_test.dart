import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:search_github_repo/views/repository_search_screen.dart';

void main() {
  group('RepositorySearchScreen', () {
    group('when build screen', () {
      testWidgets('should field loads', (tester) async {
        await _createWidget(tester);

        final textFormField = find.byType(TextFormField);
        final fieldElements = textFormField.evaluate();

        expect(textFormField, findsOneWidget);
        expect(fieldElements.length, 1);
      });

      testWidgets('should button loads', (tester) async {
        await _createWidget(tester);

        final searchButton = find.byType(ElevatedButton);
        final buttonElement = searchButton.evaluate();

        expect(searchButton, findsOneWidget);
        expect(buttonElement.length, 1);
      });
    });

    group('when search repository', () {
      group('with form field empty', () {
        testWidgets('error label loads', (tester) async {
          await _createWidget(tester);

          final searchButton = find.byType(ElevatedButton);
          await tester.tap(searchButton);
          await tester.pump();
          final Finder errorLabel = find.text('Informe uma conta GitHub');

          expect(errorLabel, findsOneWidget);
        });
      });
    });
  });
}

Future _createWidget(WidgetTester tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: RepositorySearchScreen(),
    ),
  );
}
