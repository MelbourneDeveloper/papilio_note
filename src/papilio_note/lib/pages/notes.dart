import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:papilio/bloc.dart';
import 'package:papilio/state_holder.dart';
import 'package:papilio_note/models/view_models.dart';
import 'package:papilio_note/utils/constants.dart';
import 'package:papilio_note/utils/widget_builders.dart';

class Notes extends StatelessWidget {
  const Notes();

  @override
  Widget build(BuildContext context) {
    final blocSnapshot =
        StateHolder.of<Snapshot<AppViewModel<NotesViewModel>>>(context).state;

    return Material(
        color: Theme.of(context).backgroundColor,
        child: blocSnapshot.state.pageViewModel.isLoading
            ? const SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CircularProgressIndicator.adaptive(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                ))
            : Align(
                alignment: Alignment.topCenter,
                child: Stack(children: [
                  Column(children: [
                    Expanded(
                        child: ListView(
                      key: notesListViewKey,
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(20),
                      children: blocSnapshot.state.pageViewModel.notes
                          .map((noteVm) => card(context, noteVm, blocSnapshot))
                          .toList(),
                    )),
                  ]),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 60),
                          child: Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: FloatingActionButton(
                                backgroundColor:
                                    Theme.of(context).selectedRowColor,
                                key: newNoteButtonKey,
                                onPressed: () =>
                                    blocSnapshot.sendEventSync(NewNoteEvent()),
                                child: const Align(
                                    child: Text(
                                  '+',
                                  style: TextStyle(fontSize: 32),
                                )),
                              )))),
                ])));
  }

  Widget card(BuildContext context, NoteListItemViewModel noteVm,
      Snapshot<AppViewModel<NotesViewModel>> blocSnapshot) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                getBoxShadow(context),
              ],
            ),
            child: Card(
                shape: const RoundedRectangleBorder(borderRadius: borderRadius),
                color: Theme.of(context).cardColor,
                child: TextButton(
                    onPressed: () => blocSnapshot
                        .sendEventSync(NavigateToNoteEvent(noteVm.id)),
                    key: getNoteButtonKey(noteVm.id),
                    child: SizedBox(
                        height: 170,
                        child: Column(
                          children: [
                            Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 24, 24, 0),
                                    child: SizedBox(
                                        height: 28,
                                        child: Text(
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: Theme.of(context)
                                                  .dividerColor,
                                              fontSize: 18),
                                          '• ${noteVm.title}',
                                          textAlign: TextAlign.left,
                                        )))),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 20),
                                child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                        maxHeight: 90,
                                        minWidth: double.infinity),
                                    child: Markdown(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      data: noteVm.excerpt,
                                    )))
                          ],
                        ))))));
  }
}

ValueKey<String> getNoteButtonKey(String noteId) =>
    ValueKey('NoteButton$noteId');
