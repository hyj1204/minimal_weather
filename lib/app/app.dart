// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_weather/l10n/l10n.dart';
import 'package:minimal_weather/weather/view/weather_page.dart';
import 'package:weather_repository/weather_repository.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({Key? key, required WeatherRepository weatherRepository})
      : _weatherRepository = weatherRepository,
        super(key: key);

  final WeatherRepository _weatherRepository;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _weatherRepository,
      child: const WeatherAppView(),
    );
  }
}

const Color _whiteColor = Colors.white;
const Color _darkBlackColor = Color(0xff232733);

class WeatherAppView extends StatelessWidget {
  const WeatherAppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: _darkBlackColor),
        backgroundColor: _darkBlackColor,
        textTheme: TextTheme(
            headline1: GoogleFonts.quicksand(
              fontSize: 48,
              color: _whiteColor,
              fontWeight: FontWeight.w600,
            ),
            headline2: GoogleFonts.quicksand(
              fontSize: 24,
              color: _whiteColor,
              fontWeight: FontWeight.w400,
            )),
        iconTheme: const IconThemeData(color: _darkBlackColor),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: const WeatherPage(),
    );
  }
}
