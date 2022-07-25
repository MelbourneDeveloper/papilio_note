import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:papilio/bloc.dart';
import 'package:papilio/state_holder.dart';
import 'package:papilio_note/models/view_models.dart';
import 'package:papilio_note/utils/constants.dart';
import 'package:papilio_note/utils/widget_builders.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class Note extends StatelessWidget {
  const Note({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final blocSnapshot =
        StateHolder.of<Snapshot<AppViewModel<NoteViewModel>>>(context).state;

    if (blocSnapshot.state.pageViewModel.isLoading) {
      return const CircularProgressIndicator.adaptive(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
      );
    }

    return Form(
      child: Container(
        color: Theme.of(context).backgroundColor,
        child: Column(children: [
          Padding(
            padding: topElementInsets,
            child: SizedBox(
              height: 50,
              width: double.infinity,
              child: TextFormField(
                key: noteTitleKey,
                autofocus: true,
                initialValue: blocSnapshot.state.pageViewModel.title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                decoration: borderInputDecoration(
                  context,
                  contentPadding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                ),
                onChanged: (t) async {
                  blocSnapshot.sendEventSync(ModifyNoteTitle(t));
                  //ignore: avoid-ignoring-return-values
                  await blocSnapshot.sendEvent(ModifyNoteTitle(t));
                },
              ),
            ),
          ),
          Expanded(
            child: Stack(children: [
              Padding(
                padding: followingElementInsets,
                child: TextFormField(
                  key: noteBodyKey,
                  initialValue: blocSnapshot.state.pageViewModel.body,
                  textAlignVertical: TextAlignVertical.top,
                  maxLines: null,
                  expands: true,
                  decoration: borderInputDecoration(
                    context,
                    contentPadding: const EdgeInsets.all(20),
                  ),
                  onChanged: (t) {
                    blocSnapshot.sendEventSync(ModifyBodyEvent(t));
                    //ignore: avoid-ignoring-return-values
                    blocSnapshot.sendEvent(ModifyBodyEvent(t));
                  },
                ),
              ),
              SlidingUpPanel(
                margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                maxHeight: MediaQuery.of(context).size.height * 0.95,
                minHeight: 22,
                borderRadius: const BorderRadius.all(Radius.circular(30)),
                panel: Container(
                  decoration: boxDecoration(context),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Markdown(
                      data: blocSnapshot.state.pageViewModel.body,
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
