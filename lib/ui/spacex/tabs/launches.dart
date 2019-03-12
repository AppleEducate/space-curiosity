import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../data/models/spacex/launch.dart';
import '../../general/header_swiper.dart';
import '../../general/hero_image.dart';
import '../../general/list_cell.dart';
import '../../general/loading_indicator.dart';
import '../../general/separator.dart';
import '../../general/sliver_bar.dart';
import '../pages/launch.dart';
import '../search/launches.dart';

/// LAUNCHES TAB VIEW
/// This tab holds information a specific type of launches,
/// upcoming or latest, defined by the model.
class LaunchesTab extends StatelessWidget {
  final int title;

  LaunchesTab(this.title);

  Future<Null> _onRefresh(LaunchesModel model) {
    Completer<Null> completer = Completer<Null>();
    model.refresh().then((_) => completer.complete());
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LaunchesModel>(
      builder: (context, child, model) => Scaffold(
            body: RefreshIndicator(
              onRefresh: () => _onRefresh(model),
              child: CustomScrollView(
                  key: PageStorageKey('spacex_launches_$title'),
                  slivers: <Widget>[
                    SliverBar(
                      title: Text(FlutterI18n.translate(
                        context,
                        title == 0
                            ? 'spacex.upcoming.title'
                            : 'spacex.latest.title',
                      )),
                      header: model.isLoading
                          ? LoadingIndicator()
                          : SwiperHeader(list: model.photos),
                    ),
                    model.isLoading
                        ? SliverFillRemaining(child: LoadingIndicator())
                        : SliverList(
                            delegate: SliverChildBuilderDelegate(
                              _buildLaunch,
                              childCount: model.getItemCount,
                            ),
                          ),
                  ]),
            ),
            floatingActionButton: FloatingActionButton(
              child: const Icon(Icons.search),
              tooltip: FlutterI18n.translate(
                context,
                'spacex.other.tooltip.search',
              ),
              onPressed: () => Navigator.of(context).push(
                    searchLaunches(context, model.items),
                  ),
            ),
          ),
    );
  }

  Widget _buildLaunch(BuildContext context, int index) {
    return ScopedModelDescendant<LaunchesModel>(
      builder: (context, child, model) {
        final Launch launch = model.getItem(index);
        return Column(children: <Widget>[
          ListCell(
            leading: HeroImage.list(
              url: launch.getImageUrl,
              tag: launch.getNumber,
            ),
            title: launch.name,
            subtitle: launch.getLaunchDate(context),
            trailing: MissionNumber(launch.getNumber),
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LaunchPage(launch)),
                ),
          ),
          Separator.divider(height: 0, indent: 88)
        ]);
      },
    );
  }
}
