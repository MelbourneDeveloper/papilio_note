import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

const testCaseArgsSet = [
  TestCaseArgs(
      displayInfo: DisplayInfo(
          physicalSizeTestValue: Size(1920, 1080),
          devicePixelRatioTestValue: 1,
          textScaleFactorTestValue: 1,),),
  TestCaseArgs(
      displayInfo: DisplayInfo(
          physicalSizeTestValue: Size(1080, 1920),
          devicePixelRatioTestValue: 1,
          textScaleFactorTestValue: 1,),),
  TestCaseArgs(
      displayInfo: DisplayInfo(
          physicalSizeTestValue: Size(480, 700),
          devicePixelRatioTestValue: 1,
          textScaleFactorTestValue: 1,),),
];

class TestCaseArgs {
  final DisplayInfo? displayInfo;
  final bool checkGoldens;
  const TestCaseArgs({this.displayInfo, this.checkGoldens = true});
}

class DisplayInfo {
  final double devicePixelRatioTestValue;
  final Size physicalSizeTestValue;
  final double textScaleFactorTestValue;

  const DisplayInfo(
      {required this.devicePixelRatioTestValue,
      required this.physicalSizeTestValue,
      required this.textScaleFactorTestValue,});
}

Future<void> matchesGoldenForTestCase<T>(
        String pageName, String stepName, TestCaseArgs caseArgs) =>
    caseArgs.displayInfo == null || !caseArgs.checkGoldens
        ? Future.value()
        : expectLater(
            find.byType(T),
            matchesGoldenFile('golden_files/$pageName-$stepName-macOS-'
                '${caseArgs.displayInfo!.physicalSizeTestValue.width.round()}x'
                '${caseArgs.displayInfo!.physicalSizeTestValue.height.round()}'
                '.png'),
          );

extension TesterExtensions on WidgetTester {
  void setTestDeviceDisplay(DisplayInfo displayInfo) {
    binding.window
      ..physicalSizeTestValue = displayInfo.physicalSizeTestValue
      ..devicePixelRatioTestValue = displayInfo.devicePixelRatioTestValue;
    binding.platformDispatcher.textScaleFactorTestValue =
        displayInfo.textScaleFactorTestValue;

    addTearDown(binding.window.clearPhysicalSizeTestValue);
  }

  Future tapByKeyAndSettle(Key key) async {
    await tap(find.byKey(key));
    return pumpAndSettle();
  }

  Future enterTextByKeyAndSettle(Key key, String text) async {
    await enterText(find.byKey(key), text);
    return pumpAndSettle();
  }
}

Future runTestCases(
    String name,
    Future<void> Function(WidgetTester, TestCaseArgs caseArgs)
        runTestCase,) async {
  WidgetController.hitTestWarningShouldBeFatal = true;

  testCaseArgsSet.forEach((caseArgs) async {
    testWidgets(
        "$name - "
        "${caseArgs.displayInfo!.physicalSizeTestValue.width.round()}"
        " x "
        "${caseArgs.displayInfo!.physicalSizeTestValue.height.round()}",
        (tester) async {
      if (caseArgs.displayInfo != null) {
        tester.setTestDeviceDisplay(caseArgs.displayInfo!);
      }

      await runTestCase(tester, caseArgs);
    },);
  });
}
