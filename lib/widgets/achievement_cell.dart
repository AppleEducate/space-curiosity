import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:space_news/util/colors.dart';

class AchievementCell extends StatelessWidget {
  final String title, subtitle, date, url;
  final int index;

  AchievementCell({
    this.title,
    this.subtitle,
    this.date,
    this.url,
    this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      title: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.white,
            child: Text(
              '#$index',
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.black),
            ),
          ),
          Container(width: 16.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: primaryText,
                ),
              ),
              Text(
                date,
                style: Theme.of(context).textTheme.subhead.copyWith(
                      color: primaryText,
                    ),
              ),
            ],
          ),
        ],
      ),
      subtitle: Column(
        children: <Widget>[
          Container(height: 8.0),
          Text(
            subtitle,
            textAlign: TextAlign.justify,
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(color: secondaryText),
          ),
        ],
      ),
      onTap: () async => await FlutterWebBrowser.openWebPage(
            url: url,
            androidToolbarColor: primaryColor,
          ),
    );
  }
}
