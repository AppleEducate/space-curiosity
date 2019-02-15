import 'package:add_2_calendar/add_2_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
 
import 'package:scoped_model/scoped_model.dart';
import 'package:sliver_fab/sliver_fab.dart';
import 'package:space_news/util/url.dart';

import '../../../models/spacex/details_capsule.dart';
import '../../../models/spacex/details_core.dart';
import '../../../models/spacex/landpad.dart';
import '../../../models/spacex/launch.dart';
import '../../../models/spacex/launchpad.dart';
import '../../../models/spacex/rocket.dart';
import '../../../util/colors.dart';
import '../../general/cache_image.dart';
import '../../general/card_page.dart';
import '../../general/head_card_page.dart';
import '../../general/hero_image.dart';
import '../../general/row_item.dart';
import '../../general/separator.dart';
import '../dialog/capsule.dart';
import '../dialog/core.dart';
import '../dialog/landpad.dart';
import '../dialog/launchpad.dart';

/// LAUNCH PAGE VIEW
/// This view displays all information about a specific launch.
class LaunchPage extends StatelessWidget {
  final Launch _launch;

  LaunchPage(this._launch);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => SliverFab(
              expandedHeight: MediaQuery.of(context).size.height * 0.3,
              floatingWidget: _launch.hasVideo
                  ? FloatingActionButton(
                      child: const Icon(Icons.play_arrow),
                      tooltip: FlutterI18n.translate(
                        context,
                        'spacex.other.tooltip.watch_replay',
                      ),
                      onPressed: () async =>
                          await launchURL(
                            url: _launch.getVideo,
                            androidToolbarColor: Theme.of(context).primaryColor,
                          ),
                    )
                  : AbsorbPointer(
                      absorbing: _launch.tentativeTime,
                      child: FloatingActionButton(
                        child: const Icon(Icons.event),
                        backgroundColor: _launch.tentativeTime
                            ? disabledFab
                            : Theme.of(context).accentColor,
                        tooltip: FlutterI18n.translate(
                          context,
                          'spacex.other.tooltip.add_event',
                        ),
                        onPressed: () => Add2Calendar.addEvent2Cal(Event(
                              title: _launch.name,
                              description: _launch.details,
                              location: _launch.launchpadName,
                              startDate: _launch.launchDate,
                              endDate: _launch.launchDate.add(
                                Duration(minutes: 30),
                              ),
                            )),
                      ),
                    ),
              slivers: <Widget>[
                SliverAppBar(
                  expandedHeight: MediaQuery.of(context).size.height * 0.3,
                  floating: false,
                  pinned: true,
                  actions: <Widget>[
                    PopupMenuButton<String>(
                      itemBuilder: (_) => _launch
                          .getMenu(context)
                          .map(
                            (url) => PopupMenuItem(
                                  value: url,
                                  child: Text(url),
                                  enabled: _launch.isUrlEnabled(context, url),
                                ),
                          )
                          .toList(),
                      onSelected: (name) async =>
                          await launchURL(
                            url: _launch.getUrl(context, name),
                            androidToolbarColor: Theme.of(context).primaryColor,
                          ),
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Text(_launch.name),
                    background: Swiper(
                      itemCount: _launch.getPhotosCount,
                      itemBuilder: (_, index) => CacheImage(
                            _launch.getPhoto(index),
                          ),
                      autoplay: true,
                      autoplayDelay: 6000,
                      duration: 750,
                      onTap: (index) async =>
                          await launchURL(
                            url: _launch.getPhoto(index),
                            androidToolbarColor: Theme.of(context).primaryColor,
                          ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(children: <Widget>[
                      _missionCard(context),
                      Separator.cardSpacer(),
                      _firstStageCard(context),
                      Separator.cardSpacer(),
                      _secondStageCard(context),
                    ]),
                  ),
                ),
              ],
            ),
      ),
    );
  }

  Widget _missionCard(BuildContext context) {
    return HeadCardPage(
      image: AbsorbPointer(
        absorbing: !_launch.hasImage,
        child: HeroImage.card(
          url: _launch.getImageUrl,
          tag: _launch.getNumber,
          onTap: () async => await launchURL(
                url: _launch.getImageUrl,
                androidToolbarColor: Theme.of(context).primaryColor,
              ),
        ),
      ),
      title: _launch.name,
      subtitle1: Text(
        _launch.getLaunchDate(context),
        style: Theme.of(context).textTheme.subhead.copyWith(
              color: Theme.of(context).textTheme.caption.color,
            ),
      ),
      subtitle2: InkWell(
        onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ScopedModel<LaunchpadModel>(
                      model: LaunchpadModel(
                        _launch.launchpadId,
                        _launch.launchpadName,
                      )..loadData(),
                      child: LaunchpadDialog(),
                    ),
                fullscreenDialog: true,
              ),
            ),
        child: Text(
          _launch.launchpadName,
          style: Theme.of(context).textTheme.subhead.copyWith(
                decoration: TextDecoration.underline,
                color: Theme.of(context).textTheme.caption.color,
              ),
        ),
      ),
      details: _launch.getDetails(context),
    );
  }

  Widget _firstStageCard(BuildContext context) {
    final Rocket rocket = _launch.rocket;

    return CardPage(
      title: FlutterI18n.translate(
        context,
        'spacex.launch.page.rocket.title',
      ),
      body: Column(children: <Widget>[
        RowItem.textRow(
          context,
          FlutterI18n.translate(
            context,
            'spacex.launch.page.rocket.name',
          ),
          rocket.name,
        ),
        Separator.spacer(),
        RowItem.textRow(
          context,
          FlutterI18n.translate(
            context,
            'spacex.launch.page.rocket.model',
          ),
          rocket.type,
        ),
        Separator.spacer(),
        RowItem.textRow(
          context,
          FlutterI18n.translate(
            context,
            'spacex.launch.page.rocket.static_fire_date',
          ),
          _launch.getStaticFireDate(context),
        ),
        Separator.spacer(),
        RowItem.textRow(
          context,
          FlutterI18n.translate(
            context,
            'spacex.launch.page.rocket.launch_window',
          ),
          _launch.getLaunchWindow(context),
        ),
        Separator.spacer(),
        RowItem.iconRow(
          FlutterI18n.translate(
            context,
            'spacex.launch.page.rocket.launch_success',
          ),
          _launch.launchSuccess,
        ),
        _launch.launchSuccess == false
            ? Column(children: <Widget>[
                Separator.divider(),
                RowItem.textRow(
                  context,
                  FlutterI18n.translate(
                    context,
                    'spacex.launch.page.rocket.failure.time',
                  ),
                  _launch.failureDetails.getTime,
                ),
                Separator.spacer(),
                RowItem.textRow(
                  context,
                  FlutterI18n.translate(
                    context,
                    'spacex.launch.page.rocket.failure.altitude',
                  ),
                  _launch.failureDetails.getAltitude(context),
                ),
                Separator.spacer(),
                Text(
                  _launch.failureDetails.getReason,
                  textAlign: TextAlign.justify,
                  style: Theme.of(context).textTheme.subhead.copyWith(
                        color: Theme.of(context).textTheme.caption.color,
                      ),
                ),
              ])
            : Separator.none(),
        Column(
          children: rocket.firstStage
              .map((core) => _getCores(context, core))
              .toList(),
        ),
      ]),
    );
  }

  Widget _secondStageCard(BuildContext context) {
    final SecondStage secondStage = _launch.rocket.secondStage;
    final Fairing fairing = _launch.rocket.fairing;

    return CardPage(
      title: FlutterI18n.translate(
        context,
        'spacex.launch.page.payload.title',
      ),
      body: Column(children: <Widget>[
        RowItem.textRow(
          context,
          FlutterI18n.translate(
            context,
            'spacex.launch.page.payload.second_stage.model',
          ),
          secondStage.getBlock(context),
        ),
        _launch.rocket.hasFairing
            ? Column(children: <Widget>[
                Separator.divider(),
                RowItem.iconRow(
                  FlutterI18n.translate(
                    context,
                    'spacex.launch.page.payload.fairings.reused',
                  ),
                  fairing.reused,
                ),
                Separator.spacer(),
                fairing.recoveryAttempt == true
                    ? Column(
                        children: <Widget>[
                          RowItem.iconRow(
                            FlutterI18n.translate(
                              context,
                              'spacex.launch.page.payload.fairings.recovery_success',
                            ),
                            fairing.recoverySuccess,
                          ),
                          Separator.spacer(),
                          RowItem.textRow(
                            context,
                            FlutterI18n.translate(
                              context,
                              'spacex.launch.page.payload.fairings.recovery_ship',
                            ),
                            fairing.ship,
                          ),
                        ],
                      )
                    : RowItem.iconRow(
                        FlutterI18n.translate(
                          context,
                          'spacex.launch.page.payload.fairings.recovery_attempt',
                        ),
                        fairing.recoveryAttempt,
                      ),
              ])
            : Separator.none(),
        Column(
          children: secondStage.payloads
              .map((payload) => _getPayload(context, payload))
              .toList(),
        ),
      ]),
    );
  }

  Widget _getCores(BuildContext context, Core core) {
    return Column(children: <Widget>[
      Separator.divider(),
      RowItem.dialogRow(
        context: context,
        title: FlutterI18n.translate(
          context,
          'spacex.launch.page.rocket.core.serial',
        ),
        description: core.getId(context),
        screen: ScopedModel<CoreModel>(
          model: CoreModel(core.id)..loadData(),
          child: CoreDialog(),
        ),
      ),
      Separator.spacer(),
      RowItem.textRow(
        context,
        FlutterI18n.translate(
          context,
          'spacex.launch.page.rocket.core.model',
        ),
        core.getBlock(context),
      ),
      Separator.spacer(),
      RowItem.iconRow(
        FlutterI18n.translate(
          context,
          'spacex.launch.page.rocket.core.reused',
        ),
        core.reused,
      ),
      Separator.spacer(),
      core.landingIntent == true
          ? Column(children: <Widget>[
              RowItem.dialogRow(
                context: context,
                title: FlutterI18n.translate(
                  context,
                  'spacex.launch.page.rocket.core.landing_zone',
                ),
                description: core.getLandingZone(context),
                screen: ScopedModel<LandpadModel>(
                  model: LandpadModel(core.landingZone)..loadData(),
                  child: LandpadDialog(),
                ),
              ),
              Separator.spacer(),
              RowItem.iconRow(
                FlutterI18n.translate(
                  context,
                  'spacex.launch.page.rocket.core.landing_success',
                ),
                core.landingSuccess,
              )
            ])
          : RowItem.iconRow(
              FlutterI18n.translate(
                context,
                'spacex.launch.page.rocket.core.landing_attempt',
              ),
              core.landingIntent,
            ),
    ]);
  }

  Widget _getPayload(BuildContext context, Payload payload) {
    return Column(children: <Widget>[
      Separator.divider(),
      RowItem.textRow(
        context,
        FlutterI18n.translate(
          context,
          'spacex.launch.page.payload.name',
        ),
        payload.getId(context),
      ),
      payload.isNasaPayload
          ? Column(children: <Widget>[
              Separator.spacer(),
              RowItem.dialogRow(
                context: context,
                title: FlutterI18n.translate(
                  context,
                  'spacex.launch.page.payload.capsule_serial',
                ),
                description: payload.getCapsuleSerial(context),
                screen: ScopedModel<CapsuleModel>(
                  model: CapsuleModel(payload.capsuleSerial)..loadData(),
                  child: CapsuleDialog(),
                ),
              ),
              Separator.spacer(),
              RowItem.iconRow(
                FlutterI18n.translate(
                  context,
                  'spacex.launch.page.payload.capsule_reused',
                ),
                payload.reused,
              ),
              Separator.spacer()
            ])
          : Separator.spacer(),
      RowItem.textRow(
        context,
        FlutterI18n.translate(
          context,
          'spacex.launch.page.payload.manufacturer',
        ),
        payload.getManufacturer(context),
      ),
      Separator.spacer(),
      RowItem.textRow(
        context,
        FlutterI18n.translate(
          context,
          'spacex.launch.page.payload.customer',
        ),
        payload.getCustomer(context),
      ),
      Separator.spacer(),
      RowItem.textRow(
        context,
        FlutterI18n.translate(
          context,
          'spacex.launch.page.payload.nationality',
        ),
        payload.getNationality(context),
      ),
      Separator.spacer(),
      RowItem.textRow(
        context,
        FlutterI18n.translate(
          context,
          'spacex.launch.page.payload.mass',
        ),
        payload.getMass(context),
      ),
      Separator.spacer(),
      RowItem.textRow(
        context,
        FlutterI18n.translate(
          context,
          'spacex.launch.page.payload.orbit',
        ),
        payload.getOrbit(context),
      ),
    ]);
  }
}
