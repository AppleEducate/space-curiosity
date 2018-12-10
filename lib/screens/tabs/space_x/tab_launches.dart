import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:native_widgets/native_widgets.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../models/rockets/launch.dart';
import '../../../util/colors.dart';
import '../../../widgets/cache_image.dart';
import '../../../widgets/hero_image.dart';
import '../../../widgets/list_cell.dart';
import '../../../widgets/separator.dart';
import 'page_launch.dart';
import 'search_launches.dart';

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
            key: PageStorageKey('spacex_launches_$title'),
            body: RefreshIndicator(
              onRefresh: () => _onRefresh(model),
              child: CustomScrollView(slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * 0.3,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(FlutterI18n.translate(
                      context,
                      title == 0
                          ? 'spacex.upcoming.title'
                          : 'spacex.latest.title',
                    )),
                    background: model.isLoading
                        ? NativeLoadingIndicator(center: true)
                        : Swiper(
                            itemCount: model.getPhotosCount,
                            itemBuilder: (_, index) => CacheImage(
                                  model.getPhoto(index),
                                ),
                            autoplay: true,
                            autoplayDelay: 6000,
                            duration: 750,
                            onTap: (index) async =>
                                await FlutterWebBrowser.openWebPage(
                                  url: model.getPhoto(index),
                                  androidToolbarColor: primaryColor,
                                ),
                          ),
                  ),
                ),
                model.isLoading
                    ? SliverFillRemaining(
                        child: NativeLoadingIndicator(center: true),
                      )
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
            subtitle: launch.getLaunchDate,
            trailing: MissionNumber(launch.getNumber),
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LaunchPage(launch)),
                ),
          ),
          Separator.divider(height: 0.0, indent: 96.0)
        ]);
      },
    );
  }
}
