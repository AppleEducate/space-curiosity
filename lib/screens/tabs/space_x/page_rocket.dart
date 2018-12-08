import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import '../../../models/rockets/info_rocket.dart';
import '../../../util/colors.dart';
import '../../../widgets/card_page.dart';
import '../../../widgets/row_item.dart';
import '../../../widgets/separator.dart';

/// ROCKET PAGE CLASS
/// This class represent a rocket page. It displays RocketInfo's specs.
class RocketPage extends StatelessWidget {
  final RocketInfo _rocket;

  RocketPage(this._rocket);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: MediaQuery.of(context).size.height * 0.3,
            floating: false,
            pinned: true,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.public),
                onPressed: () async => await FlutterWebBrowser.openWebPage(
                    url: _rocket.url, androidToolbarColor: primaryColor),
                tooltip: FlutterI18n.translate(
                  context,
                  'spacex.other.menu.wikipedia',
                ),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(_rocket.name),
              background: Swiper(
                itemCount: _rocket.getPhotosCount,
                itemBuilder: _buildImage,
                autoplay: true,
                autoplayDelay: 6000,
                duration: 750,
                onTap: (index) async => await FlutterWebBrowser.openWebPage(
                      url: _rocket.getPhoto(index),
                      androidToolbarColor: primaryColor,
                    ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                _rocketCard(context),
                Separator.cardSpacer(),
                _specsCard(context),
                Separator.cardSpacer(),
                _payloadsCard(context),
                Separator.cardSpacer(),
                _firstStage(context),
                Separator.cardSpacer(),
                _secondStage(context),
                Separator.cardSpacer(),
                _enginesCard(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rocketCard(BuildContext context) {
    return CardPage(
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.rocket.description.title',
      ),
      body: Column(
        children: <Widget>[
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.description.launch_maiden',
            ),
            _rocket.getFullFirstFlight,
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.description.launch_cost',
            ),
            _rocket.getLaunchCost,
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.description.success_rate',
            ),
            _rocket.getSuccessRate(context),
          ),
          Separator.spacer(),
          RowItem.iconRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.description.active',
            ),
            _rocket.active,
          ),
          Separator.divider(),
          Text(
            _rocket.description,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 15.0, color: secondaryText),
          )
        ],
      ),
    );
  }

  Widget _specsCard(BuildContext context) {
    return CardPage(
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.rocket.specifications.title',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.specifications.rocket_stages',
            ),
            _rocket.getStages(context),
          ),
          Separator.divider(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.specifications.height',
            ),
            _rocket.getHeight,
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.specifications.diameter',
            ),
            _rocket.getDiameter,
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.specifications.mass',
            ),
            _rocket.getMass(context),
          ),
          Separator.divider(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.stage.fairing_height',
            ),
            _rocket.fairingHeight(context),
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.stage.fairing_diameter',
            ),
            _rocket.fairingDiameter(context),
          ),
        ],
      ),
    );
  }

  Widget _payloadsCard(BuildContext context) {
    return CardPage(
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.rocket.capability.title',
      ),
      body: Column(
        children: _rocket.payloadWeights
            .map(
              (mission) => _getPayloadWeight(
                    context,
                    _rocket.payloadWeights,
                    mission,
                  ),
            )
            .toList(),
      ),
    );
  }

  Column _getPayloadWeight(
    BuildContext context,
    List payloadWeights,
    PayloadWeight payloadWeight,
  ) {
    return Column(
      children: <Widget>[
        RowItem.textRow(
          payloadWeight.name,
          payloadWeight.getMass,
        ),
      ]..add(
          payloadWeight != payloadWeights.last
              ? Separator.spacer()
              : Separator.none(),
        ),
    );
  }

  Widget _firstStage(BuildContext context) {
    return CardPage(
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.rocket.stage.stage_first',
      ),
      body: Column(
        children: <Widget>[
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.stage.fuel_amount',
            ),
            _rocket.firstStage.getFuelAmount(context),
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.stage.engines',
            ),
            _rocket.firstStage.getEngines(context),
          ),
          Separator.spacer(),
          RowItem.iconRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.stage.reusable',
            ),
            _rocket.firstStage.reusable,
          ),
          Separator.divider(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.engines.thrust_sea',
            ),
            _rocket.firstStage.getThrustSea,
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.engines.thrust_vacuum',
            ),
            _rocket.firstStage.getThrustVacuum,
          ),
        ],
      ),
    );
  }

  Widget _secondStage(BuildContext context) {
    return CardPage(
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.rocket.stage.stage_second',
      ),
      body: Column(
        children: <Widget>[
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.stage.fuel_amount',
            ),
            _rocket.secondStage.getFuelAmount(context),
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.stage.engines',
            ),
            _rocket.secondStage.getEngines(context),
          ),
          Separator.spacer(),
          RowItem.iconRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.stage.reusable',
            ),
            _rocket.secondStage.reusable,
          ),
          Separator.divider(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.engines.thrust_vacuum',
            ),
            _rocket.secondStage.getThrustVacuum,
          ),
        ],
      ),
    );
  }

  Widget _enginesCard(BuildContext context) {
    return CardPage(
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.rocket.engines.title',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.engines.model',
            ),
            _rocket.getEngine,
          ),
          Separator.divider(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.engines.fuel',
            ),
            _rocket.getFuel,
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.engines.oxidizer',
            ),
            _rocket.getOxidizer,
          ),
          Separator.divider(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.engines.thrust_weight',
            ),
            _rocket.getEngineThrustToWeight(context),
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.engines.thrust_sea',
            ),
            _rocket.getEngineThrustSea,
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.rocket.engines.thrust_vacuum',
            ),
            _rocket.getEngineThrustVacuum,
          ),
        ],
      ),
    );
  }

  Widget _buildImage(BuildContext context, int index) {
    CachedNetworkImage photo = CachedNetworkImage(
      imageUrl: _rocket.getPhoto(index),
      errorWidget: const Icon(Icons.error),
      fadeInDuration: Duration(milliseconds: 100),
      fit: BoxFit.cover,
    );
    if (index == 0)
      return Hero(tag: _rocket.id, child: photo);
    else
      return photo;
  }
}
