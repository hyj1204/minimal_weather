import 'package:flutter/material.dart';
import 'package:minimal_weather/weather/weather.dart';
import 'package:provider/src/provider.dart';

class AnimatedSearchBar extends StatefulWidget {
  const AnimatedSearchBar({Key? key}) : super(key: key);

  @override
  _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
  bool _folded = true;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: _folded ? 56 : 300,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        color: _folded ? theme.backgroundColor : Colors.white,
      ),
      child: Row(children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 16),
            child: _folded
                ? null
                : TextField(
                    autofocus: true,
                    cursorColor: theme.backgroundColor,
                    decoration: InputDecoration(
                      hintText: 'Search a city',
                      hintStyle: TextStyle(color: theme.backgroundColor),
                      border: InputBorder.none,
                    ),
                    keyboardType: TextInputType.text,
                    onEditingComplete: () {
                      setState(() {
                        _folded = !_folded;
                      });
                    },
                    onSubmitted: (value) async {
                      await context.read<WeatherCubit>().fetchWeather(value);
                    },
                  ),
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                _folded = !_folded;
              });
            },
            icon: Icon(
              _folded ? Icons.search_outlined : Icons.close,
              color: _folded ? Colors.white : theme.backgroundColor,
            ))
      ]),
    );
  }
}
