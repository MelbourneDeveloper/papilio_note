import 'package:flutter/material.dart';
import 'package:ioc_container/ioc_container.dart';
import 'package:papilio/papilio_route_information_parser.dart';
import 'package:papilio/papilio_router_delegate.dart';
import 'package:papilio_note/models/data_model.dart';
import 'package:papilio_note/models/note_route_path.dart';
import 'package:papilio_note/utils/constants.dart';

class AppRoot extends StatefulWidget {
  final IocContainer container;

  AppRoot(
    this.container, {
    Key? key,
  }) : super(key: key);

  @override
  State<AppRoot> createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    widget.container.get<PersistedModelWrapper>().addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate:
            widget.container.get<PapilioRouterDelegate<AppRouteInfo>>(),
        routeInformationParser:
            widget.container.get<PapilioRouteInformationParser<AppRouteInfo>>(),
        theme: widget.container
                .get<PersistedModelWrapper>()
                .model
                .settings
                .isDarkMode
            ? darkTheme
            : lightTheme,
      );
}
