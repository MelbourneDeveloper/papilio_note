import 'package:flutter/material.dart';
import 'package:papilio/bloc.dart';
import 'package:papilio/state_holder.dart';
import 'package:papilio_note/models/view_models.dart';
import 'package:papilio_note/utils/constants.dart';
import 'package:papilio_note/utils/widget_builders.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocSnapshot =
        StateHolder.of<Snapshot<AppViewModel<SettingsViewModel>>>(context)
            .state;

    return SizedBox(
      height: double.infinity,
      child: Stack(children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Material(
            color: Theme.of(context).backgroundColor,
          ),
        ),
        Align(
          child: Container(
            height: 100,
            width: 300,
            decoration: boxDecoration(context),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Dark Mode',
                  ),
                  Checkbox(
                    key: darkModeCheckBoxKey,
                    checkColor: Theme.of(context).cardColor,
                    fillColor: MaterialStateProperty.resolveWith(
                      (materialStates) => Theme.of(context).indicatorColor,
                    ),
                    value: blocSnapshot.state.pageViewModel.isDarkMode,
                    onChanged: (value) {
                      blocSnapshot.sendEvent(SetTheme(value!));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
