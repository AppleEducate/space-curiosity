import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dynamic_theme/dynamic_theme.dart';

import 'models/planets/celestial_body.dart';
import 'screens/screen_home.dart';
import 'screens/tabs/news/screen_news.dart';
import 'screens/tabs/planets/add_edit_planet.dart';
import 'screens/tabs/planets/screen_solar_system.dart';
import 'screens/tabs/space_x/screen_spacex.dart';
import 'util/colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Brightness _defaultBrightness = Brightness.dark;
    print(_defaultBrightness == Brightness.dark);
    return new DynamicTheme(
        defaultBrightness: _defaultBrightness,
        data: (brightness) {
          if (brightness == Brightness.dark) {
            return ThemeData.dark();
            // return new ThemeData(
            //   brightness: Brightness.dark,
            //   fontFamily: 'ProductSans',
            //   primaryColor: primaryColor,
            //   accentColor: accentColor,
            //   canvasColor: backgroundColor,
            //   cardColor: cardColor,
            //   dialogBackgroundColor: cardColor,
            //   dividerColor: dividerColor,
            //   highlightColor: highlightColor,
            // );
          } else {
            return ThemeData.light();
            // return new ThemeData(
            //   brightness: Brightness.light,
            //   fontFamily: 'ProductSans',
            //   primaryColor: primaryColor,
            //   accentColor: accentColor,
            //   canvasColor: backgroundColor,
            //   cardColor: cardColor,
            //   dialogBackgroundColor: cardColor,
            //   dividerColor: dividerColor,
            //   highlightColor: highlightColor,
            // );
          }
        },
        themedWidgetBuilder: (context, theme) {
          return new MaterialApp(
            title: 'Space Curiosity',
            theme: theme,
            home: HomeScreen(),
            debugShowCheckedModeBanner: false,
            routes: <String, WidgetBuilder>{
              '/home': (_) => HomeScreen(),
              '/space_x': (_) => SpacexScreen(),
              '/news': (_) => NewsScreen(),
              '/planets': (_) => SolarSystemScreen(),
              AddEditPlanetPage.routeName: (_) =>
                  AddEditPlanetPage(null, type: BodyType.planet),
            },
            localizationsDelegates: [
              FlutterI18nDelegate(false, 'en'),
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
          );
        });
  }
}
