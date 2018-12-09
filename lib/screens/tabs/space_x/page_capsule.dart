import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';

import '../../../models/rockets/info_capsule.dart';
import '../../../util/colors.dart';
import '../../../widgets/card_page.dart';
import '../../../widgets/row_item.dart';
import '../../../widgets/separator.dart';

/// CAPSULE PAGE CLASS
/// This class represent a capsule page. It displays CapsuleInfo's specs.
class CapsulePage extends StatelessWidget {
  final CapsuleInfo _capsule;

  CapsulePage(this._capsule);

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
                      url: _capsule.url,
                      androidToolbarColor: primaryColor,
                    ),
                tooltip: FlutterI18n.translate(
                  context,
                  'spacex.other.menu.wikipedia',
                ),
              )
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(_capsule.name),
              background: Swiper(
                itemCount: _capsule.getPhotosCount,
                itemBuilder: _buildImage,
                autoplay: true,
                autoplayDelay: 6000,
                duration: 750,
                onTap: (index) async => await FlutterWebBrowser.openWebPage(
                      url: _capsule.getPhoto(index),
                      androidToolbarColor: primaryColor,
                    ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: <Widget>[
                _capsuleCard(context),
                Separator.cardSpacer(),
                _specsCard(context),
                Separator.cardSpacer(),
                _thrustersCard(context),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _capsuleCard(BuildContext context) {
    return CardPage(
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.capsule.description.title',
      ),
      body: Column(children: <Widget>[
        RowItem.textRow(
          FlutterI18n.translate(
            context,
            'spacex.vehicle.capsule.description.launch_maiden',
          ),
          _capsule.getFullFirstFlight,
        ),
        Separator.spacer(),
        RowItem.textRow(
          FlutterI18n.translate(
            context,
            'spacex.vehicle.capsule.description.crew_capacity',
          ),
          _capsule.getCrew(context),
        ),
        Separator.spacer(),
        RowItem.iconRow(
          FlutterI18n.translate(
            context,
            'spacex.vehicle.capsule.description.active',
          ),
          _capsule.active,
        ),
        Separator.divider(),
        Text(
          _capsule.description,
          textAlign: TextAlign.justify,
          style: TextStyle(fontSize: 15.0, color: secondaryText),
        )
      ]),
    );
  }

  Widget _specsCard(BuildContext context) {
    return CardPage(
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.capsule.specifications.title',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.capsule.specifications.payload_launch',
            ),
            _capsule.getLaunchMass,
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.capsule.specifications.payload_return',
            ),
            _capsule.getReturnMass,
          ),
          Separator.spacer(),
          RowItem.iconRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.capsule.description.reusable',
            ),
            _capsule.reusable,
          ),
          Separator.divider(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.capsule.specifications.height',
            ),
            _capsule.getHeight,
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.capsule.specifications.diameter',
            ),
            _capsule.getDiameter,
          ),
          Separator.spacer(),
          RowItem.textRow(
            FlutterI18n.translate(
              context,
              'spacex.vehicle.capsule.specifications.mass',
            ),
            _capsule.getMass(context),
          ),
        ],
      ),
    );
  }

  Widget _thrustersCard(BuildContext context) {
    return CardPage(
      title: FlutterI18n.translate(
        context,
        'spacex.vehicle.capsule.thruster.title',
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RowItem.textRow(
              FlutterI18n.translate(
                context,
                'spacex.vehicle.capsule.thruster.systems',
              ),
              _capsule.getThrusters),
          Column(
            children: _capsule.thrusters
                .map((thruster) => _getThruster(context, thruster))
                .toList(),
          )
        ],
      ),
    );
  }

  Widget _getThruster(BuildContext context, Thruster thruster) {
    return Column(children: <Widget>[
      Separator.divider(),
      RowItem.textRow(
        FlutterI18n.translate(
          context,
          'spacex.vehicle.capsule.thruster.name',
        ),
        thruster.name,
      ),
      Separator.spacer(),
      RowItem.textRow(
        FlutterI18n.translate(
          context,
          'spacex.vehicle.capsule.thruster.amount',
        ),
        thruster.getAmount,
      ),
      Separator.spacer(),
      RowItem.textRow(
        FlutterI18n.translate(
          context,
          'spacex.vehicle.capsule.thruster.fuel',
        ),
        thruster.getFuel,
      ),
      Separator.spacer(),
      RowItem.textRow(
        FlutterI18n.translate(
          context,
          'spacex.vehicle.capsule.thruster.oxidizer',
        ),
        thruster.getOxidizer,
      ),
      Separator.spacer(),
      RowItem.textRow(
        FlutterI18n.translate(
          context,
          'spacex.vehicle.capsule.thruster.thrust',
        ),
        thruster.getThrust,
      ),
    ]);
  }

  Widget _buildImage(BuildContext context, int index) {
    final CachedNetworkImage photo = CachedNetworkImage(
      imageUrl: _capsule.getPhoto(index),
      errorWidget: const Icon(Icons.error),
      fadeInDuration: Duration(milliseconds: 100),
      fit: BoxFit.cover,
    );

    return index == 0 ? Hero(tag: _capsule.id, child: photo) : photo;
  }
}
