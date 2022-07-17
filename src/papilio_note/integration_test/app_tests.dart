import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../test/app_test.dart';
import '../test/helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Test', () {
    WidgetController.hitTestWarningShouldBeFatal = true;

    testWidgets(
        'App Test', (tester) => testNotesPage(tester, const TestCaseArgs()));
  });
}
