import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

//TODO:add blocProvider

const Color _blackColor = Color(0xff232733);
const Color _lightBlueColor = Color(0xffdbe5f0);

class WeatherView extends StatelessWidget {
  const WeatherView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _lightBlueColor,
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '74:temp',
            style: GoogleFonts.quicksand(
              fontSize: 100,
              color: _blackColor,
              fontWeight: FontWeight.w200,
            ),
          ),
          Text(
            'Sunny',
            style: GoogleFonts.quicksand(
              fontSize: 40,
              color: _blackColor,
              fontWeight: FontWeight.w400,
            ),
          ),
        ]),
      ),
    );
  }
}
