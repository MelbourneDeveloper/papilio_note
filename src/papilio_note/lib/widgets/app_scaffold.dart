import 'package:flutter/material.dart';
import 'package:navigation_drawer_menu/navigation_drawer.dart';
import 'package:navigation_drawer_menu/navigation_drawer_menu.dart';
import 'package:navigation_drawer_menu/navigation_drawer_menu_frame.dart';
import 'package:navigation_drawer_menu/navigation_drawer_state.dart';
import 'package:papilio/bloc.dart';
import 'package:papilio/state_holder.dart';
import 'package:papilio_note/models/view_models.dart';
import 'package:papilio_note/utils/constants.dart';

final menuItems = [
  MenuItemContent(
      menuItem:
          MenuItemDefinition("Back", backKey, iconData: Icons.navigate_before)),
  MenuItemContent(
      menuItem: MenuItemDefinition("Notes", notesKey, iconData: Icons.notes)),
  MenuItemContent(
      menuItem:
          MenuItemDefinition("New Note", newNoteKey, iconData: Icons.note_add)),
  MenuItemContent(
      widget: const SizedBox(
    height: 30,
  )),
  MenuItemContent(
      menuItem:
          MenuItemDefinition("Settings", settingsKey, iconData: Icons.settings))
];

class AppScaffold<T> extends StatelessWidget {
  final Widget body;
  final void Function(
          BuildContext context, ValueKey<String>? selectedMenuItemKey)
      onMenuItemSelected;
  final void Function(BuildContext context) onHamburgerPressed;
  final MenuMode menuMode;
  final NavigationDrawerState navigationDrawerState;

  const AppScaffold({
    required this.menuMode,
    required this.body,
    required this.onMenuItemSelected,
    required this.onHamburgerPressed,
    required this.navigationDrawerState,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final snapshot = StateHolder.of<Snapshot<AppViewModel<T>>>(context).state;

    return Scaffold(
      drawer: NavigationDrawer(
          key: drawerKey,
          menuMode: menuMode,
          menuBuilder: Builder(
              builder: (c) => getMenu(c, navigationDrawerState, snapshot))),
      body: NavigationDrawerMenuFrame(
        menuMode: menuMode,
        menuBackgroundColor: Theme.of(context).cardColor,
        body: Container(
            color: Theme.of(context).cardColor,
            alignment: Alignment.center,
            height: double.maxFinite,
            child: body),
        menuBuilder: Builder(
            builder: (c) => getMenu(c, navigationDrawerState, snapshot)),
      ),
      appBar: AppBar(
        elevation: .5,
        title: Text(snapshot.state.title),
        leading: Builder(
            builder: (context) => IconButton(
                  key: hamburgerButtonKey,
                  icon: Icon(
                    color: Theme.of(context).appBarTheme.foregroundColor,
                    Icons.menu,
                  ),
                  onPressed: () {
                    onHamburgerPressed(context);
                    snapshot.sendEventSync(RebuildEvent());
                  },
                  tooltip: 'Toggle the menu',
                )),
      ),
    );
  }

  Widget getMenu(BuildContext context, NavigationDrawerState state,
          Snapshot<AppViewModel<dynamic>> snapshot) =>
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        NavigationDrawerMenu(
            highlightColor: Theme.of(context).indicatorColor,
            onSelectionChanged: (c, key) {
              onMenuItemSelected(c, key);
              state.closeDrawer(c);
              snapshot.sendEventSync(RebuildEvent());
            },
            menuItems: menuItems,
            selectedMenuKey: snapshot.state.selectedPageKey,
            itemPadding: const EdgeInsets.only(left: 5, right: 5),
            buildMenuButtonContent: (menuItemDefinition, isSelected,
                    buildContentContext) =>
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(menuItemDefinition.iconData,
                      color: isSelected
                          ? Theme.of(buildContentContext).backgroundColor
                          : Theme.of(buildContentContext)
                              .textTheme
                              .bodyText2!
                              .color),
                  if (state.menuMode(context) != MenuMode.Thin)
                    const SizedBox(
                      width: 10,
                    ),
                  if (state.menuMode(context) != MenuMode.Thin)
                    Text(menuItemDefinition.text,
                        style: isSelected
                            ? Theme.of(context).textTheme.bodyText2!.copyWith(
                                color: Theme.of(buildContentContext)
                                    .backgroundColor)
                            : Theme.of(buildContentContext).textTheme.bodyText2)
                ]))
      ]);
}
