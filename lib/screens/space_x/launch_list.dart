import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../models/rockets/launch.dart';
import '../../widgets/hero_image.dart';
import '../../widgets/list_cell.dart';
import 'launch_page.dart';

/// LAUNCH LIST CLASS
/// Displays a list made out of launches, downloading them using the url.
/// Uses a ListCell item for each launch.
class LaunchList extends StatelessWidget {
  final String _url;

  LaunchList(this._url);

  /// Downloads the list of launches
  Future<List<Launch>> fetchPost() async {
    final response = await http.get(_url);

    List jsonDecoded = json.decode(response.body);
    return jsonDecoded.map((m) => Launch.fromJson(m)).toList();
  }

  @override
  Widget build(BuildContext context) {
    // Checks if list is cached
    if (PageStorage
            .of(context)
            .readState(context, identifier: ValueKey(_url)) ==
        null)
      PageStorage
          .of(context)
          .writeState(context, fetchPost(), identifier: ValueKey(_url));

    return Center(
      child: FutureBuilder<List<Launch>>(
        future: PageStorage.of(context).readState(
              context,
              identifier: ValueKey(_url),
            ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            default:
              if (!snapshot.hasError) {
                final List<Launch> launches = snapshot.data;
                return Scrollbar(
                  child: ListView.builder(
                    key: PageStorageKey(_url),
                    itemCount: launches.length,
                    itemBuilder: (context, index) {
                      // Final vars used to display a launch
                      final Launch launch = launches[index];
                      final VoidCallback onClick = () {
                        Navigator.of(context).push(
                          PageRouteBuilder<Null>(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return AnimatedBuilder(
                                animation: animation,
                                builder: (context, child) {
                                  return Opacity(
                                    opacity: const Interval(0.0, 0.75,
                                            curve: Curves.fastOutSlowIn)
                                        .transform(animation.value),
                                    child: LaunchPage(launch),
                                  );
                                },
                              );
                            },
                          ),
                        );
                      };

                      // Displays the launch with a ListCell item
                      return Column(children: <Widget>[
                        ListCell(
                          leading: HeroImage().buildHero(
                            context: context,
                            url: launch.getImageUrl,
                            tag: launch.getNumber,
                            title: launch.name,
                            onClick: onClick,
                          ),
                          title: launch.name,
                          subtitle: launch.getLaunchDate,
                          trailing: MissionNumber(launch.getNumber),
                          onTap: onClick,
                        ),
                        const Divider(height: 0.0, indent: 104.0)
                      ]);
                    },
                  ),
                );
              } else
                return const Text("Couldn't connect to server...");
          }
        },
      ),
    );
  }
}
