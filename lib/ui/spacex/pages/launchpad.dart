import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../../data/models/spacex/launchpad.dart';
import '../../general/expand_widget.dart';
import '../../general/header_map.dart';
import '../../general/loading_indicator.dart';
import '../../general/row_item.dart';
import '../../general/separator.dart';
import '../../general/sliver_bar.dart';

/// LAUNCHPAD PAGE VIEW
/// This view displays information about a specific launchpad,
/// where rockets get rocketed to the sky...
class LaunchpadPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<LaunchpadModel>(
      builder: (context, child, model) => Scaffold(
            body: CustomScrollView(slivers: <Widget>[
              SliverBar(
                title: Text(model.name),
                header: model.isLoading
                    ? LoadingIndicator()
                    : MapHeader(model.launchpad.coordinates),
              ),
              model.isLoading
                  ? SliverFillRemaining(child: LoadingIndicator())
                  : SliverToBoxAdapter(child: _buildBody())
            ]),
          ),
    );
  }

  Widget _buildBody() {
    return ScopedModelDescendant<LaunchpadModel>(
      builder: (context, child, model) => Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: <Widget>[
              Text(
                model.launchpad.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.title,
              ),
              Separator.spacer(),
              RowItem.textRow(
                context,
                FlutterI18n.translate(
                  context,
                  'spacex.dialog.pad.status',
                ),
                model.launchpad.getStatus,
              ),
              Separator.spacer(),
              RowItem.textRow(
                context,
                FlutterI18n.translate(
                  context,
                  'spacex.dialog.pad.location',
                ),
                model.launchpad.location,
              ),
              Separator.spacer(),
              RowItem.textRow(
                context,
                FlutterI18n.translate(
                  context,
                  'spacex.dialog.pad.state',
                ),
                model.launchpad.state,
              ),
              Separator.spacer(),
              RowItem.textRow(
                context,
                FlutterI18n.translate(
                  context,
                  'spacex.dialog.pad.coordinates',
                ),
                model.launchpad.getCoordinates,
              ),
              Separator.spacer(),
              RowItem.textRow(
                context,
                FlutterI18n.translate(
                  context,
                  'spacex.dialog.pad.launches_successful',
                ),
                model.launchpad.getSuccessfulLaunches,
              ),
              Separator.divider(),
              TextExpand(
                text: model.launchpad.details,
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
}
