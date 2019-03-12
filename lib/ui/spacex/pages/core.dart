import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../data/models/spacex/details_core.dart';
import '../../../data/models/spacex/mission_item.dart';
import '../../general/expand_widget.dart';
import '../../general/header_swiper.dart';
import '../../general/loading_indicator.dart';
import '../../general/row_item.dart';
import '../../general/separator.dart';
import '../../general/sliver_bar.dart';

/// CORE DIALOG VIEW
/// This view displays information about a specific core,
/// used in a mission.
class CoreDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<CoreModel>(
      builder: (context, child, model) => Scaffold(
            body: CustomScrollView(slivers: <Widget>[
              SliverBar(
                title: Text(FlutterI18n.translate(
                  context,
                  'spacex.dialog.vehicle.title_core',
                  {'serial': model.id},
                )),
                header: model.isLoading
                    ? LoadingIndicator()
                    : SwiperHeader(list: model.photos),
              ),
              model.isLoading
                  ? SliverFillRemaining(child: LoadingIndicator())
                  : SliverToBoxAdapter(child: _buildBody())
            ]),
          ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<CoreModel>(
      builder: (context, child, model) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: <Widget>[
              RowItem.textRow(
                context,
                FlutterI18n.translate(
                  context,
                  'spacex.dialog.vehicle.model',
                ),
                model.core.getBlock(context),
              ),
              Separator.spacer(),
              RowItem.textRow(
                context,
                FlutterI18n.translate(
                  context,
                  'spacex.dialog.vehicle.status',
                ),
                model.core.getStatus,
              ),
              Separator.spacer(),
              RowItem.textRow(
                context,
                FlutterI18n.translate(
                  context,
                  'spacex.dialog.vehicle.first_launched',
                ),
                model.core.getFirstLaunched(context),
              ),
              Separator.spacer(),
              RowItem.textRow(
                context,
                FlutterI18n.translate(
                  context,
                  'spacex.dialog.vehicle.launches',
                ),
                model.core.getLaunches,
              ),
              Separator.spacer(),
              RowItem.textRow(
                context,
                FlutterI18n.translate(
                  context,
                  'spacex.dialog.vehicle.landings_rtls',
                ),
                model.core.getRtlsLandings,
              ),
              Separator.spacer(),
              RowItem.textRow(
                context,
                FlutterI18n.translate(
                  context,
                  'spacex.dialog.vehicle.landings_asds',
                ),
                model.core.getAsdsLandings,
              ),
              Separator.divider(),
              model.core.hasMissions
                  ? Column(children: <Widget>[
                      Column(
                        children: model.core.missions
                            .map((mission) => _getMission(
                                  context,
                                  model.core.missions,
                                  mission,
                                ))
                            .toList(),
                      ),
                      Separator.divider(),
                    ])
                  : Separator.none(),
              TextExpand(
                text: model.core.getDetails(context),
                maxLength: 8,
                style: TextStyle(
                  color: Theme.of(context).textTheme.caption.color,
                  fontSize: 15,
                ),
              )
            ]),
          ),
    );
  }

  Column _getMission(BuildContext context, List missions, MissionItem mission) {
    return Column(children: <Widget>[
      RowItem.textRow(
        context,
        FlutterI18n.translate(
          context,
          'spacex.dialog.vehicle.mission',
          {'number': mission.id.toString()},
        ),
        mission.name,
      ),
      mission != missions.last ? Separator.spacer() : Separator.none(),
    ]);
  }
}
