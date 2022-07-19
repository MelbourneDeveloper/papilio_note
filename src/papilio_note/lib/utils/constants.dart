import 'package:flutter/material.dart';
import 'package:papilio_note/models/note_route_path.dart';

//Colors
//https://colors.artyclick.com/color-names-dictionary/colors/38ACEC
const butterflyBlue = Color(0xFF38ACEC);
const background = Color(0xFFE7F5FD);
const darkBackground = Color(0xFF329AD2);
const borderColor = Color(0XFF194D69);
const shadowColor = Color(0xFFA3D9F7);
const indicatorColor = Color(0xFF329AD2);
const darkText = Color(0xFF2C87B8);

final lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: "Raleway",
    selectedRowColor: butterflyBlue,
    backgroundColor: background,
    cardColor: Colors.white,
    shadowColor: shadowColor,
    indicatorColor: indicatorColor,
    dividerColor: darkText,
    appBarTheme: const AppBarTheme(
      foregroundColor: Colors.white,
      color: darkBackground,
      elevation: .5,
      iconTheme: IconThemeData(color: Colors.black),
    ));

final darkTheme = ThemeData(
  dividerColor: const Color(0xFFD0ECFB),
  brightness: Brightness.dark,
  primaryColor: Colors.white,
  indicatorColor: indicatorColor,
  shadowColor: const Color(0xFF38AEED),
  fontFamily: "Raleway",
  backgroundColor: const Color(0xFF123A4F),
  cardColor: const Color(0xFF06131A),
);

const defaultRouteInfo = AppRouteInfo(RouteLocation.notes);

const excerptLength = 300;

const double minimumMenuWidth = 500;

//Keys
const backKey = ValueKey('Back');
const notesKey = ValueKey('/notes');
const newNoteKey = ValueKey('/note');
const settingsKey = ValueKey('/settings');

const notesListViewKey = ValueKey('notesListViewKey');
const noteTitleKey = ValueKey('noteTitleKey');
const noteBodyKey = ValueKey('noteBodyKey');

const drawerKey = ValueKey('drawerkey');
const hamburgerButtonKey = ValueKey('hamburgerbuttonKey');
const newNoteButtonKey = ValueKey('newNoteButtonKey');
const darkModeCheckBoxKey = ValueKey('darkModeCheckBoxKey');

const dataFilename = "data.json";

const radius = Radius.circular(30);

const borderRadius = BorderRadius.all(radius);

const double paddingValue = 20;

const topElementInsets = EdgeInsets.all(paddingValue);

const followingElementInsets =
    EdgeInsets.fromLTRB(paddingValue, 0, paddingValue, paddingValue);

const markdownExample = '''
Lorem ipsum dolor sit amet, *consectetur* adipisicing elit, sed do eiusmod
tempor incididunt ut **labore et dolore magna aliqua**. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. ***Duis aute irure dolor*** in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. ~~Excepteur sint occaecat~~ cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

## H2

Lorem ipsum dolor sit amet, *consectetur* adipisicing elit, sed do eiusmod
tempor incididunt ut **labore et dolore magna aliqua**. Ut enim ad minim veniam,
quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
consequat. 

---

***Duis aute irure dolor*** in reprehenderit in voluptate velit esse
cillum dolore eu fugiat nulla pariatur. ~~Excepteur sint occaecat~~ cupidatat non
proident, sunt in culpa qui officia deserunt mollit anim id est laborum.

### H3

unordered list:

* item-1
  * sub-item-1
  * sub-item-2
- item-2
  - sub-item-3
  - sub-item-4
+ item-3
  + sub-item-5
  + sub-item-6


ordered list:

1. item-1
   1. sub-item-1
   2. sub-item-2
2. item-2
   1. sub-item-3
   2. sub-item-4
3. item-3

#### Header4

Table Header-1 | Table Header-2 | Table Header-3
:--- | :---: | ---:
Table Data-1 | Table Data-2 | Table Data-3
TD-4 | Td-5 | TD-6
Table Data-7 | Table Data-8 | Table Data-9

##### Header5

You may also want some images right in here like (missing image) - you can do that but I would recommend you to use the component "image" and simply split your text.

###### Header6

Let us do some links - this for example: https://github.com/MinhasKamal/github-markdown-syntax is **NOT** a link but this: is [GitHub](https://github.com/MinhasKamal/github-markdown-syntax)''';
