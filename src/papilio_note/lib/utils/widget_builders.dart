import 'package:flutter/material.dart';
import 'package:papilio_note/utils/constants.dart';

BoxDecoration boxDecoration(BuildContext context) => BoxDecoration(
      borderRadius: borderRadius,
      color: Theme.of(context).cardColor,
    );

BoxShadow getBoxShadow(BuildContext context) => BoxShadow(
      color: Theme.of(context).shadowColor.withOpacity(.2),
      spreadRadius: 1,
      blurRadius: 10,
      offset: const Offset(5, 5), // changes position of shadow
    );

InputDecoration borderInputDecoration(BuildContext context,
        {EdgeInsets? contentPadding}) =>
    InputDecoration(
      fillColor: Theme.of(context).cardColor,
      filled: true,
      hoverColor: Theme.of(context).cardColor,
      contentPadding: contentPadding,
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: borderColor),
          borderRadius: borderRadius),
      enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
          borderRadius: borderRadius),
    );
