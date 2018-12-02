import 'dart:convert';
import 'dart:math';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../util/url.dart';
import '../querry_model.dart';
import 'rocket.dart';

/// LAUNCHES MODEL
/// Model which storages information about
/// past or futures launches, depending on [type].
///   [type] == 0 => Upcoming launches
///   [type] == 1 => Latest launches
class LaunchesModel extends QuerryModel {
  final int type;

  LaunchesModel(this.type);

  @override
  Future loadData() async {
    // Get item by http call & parse it
    response = await http.get(type == 0 ? Url.upcomingList : Url.launchesList);
    snapshot = json.decode(response.body);

    // Clear old data
    clearItems();

    // Added parsed items
    items.addAll(snapshot.map((launch) => Launch.fromJson(launch)).toList());

    // Adds photos & shuffle them
    if (photos.isEmpty) {
      if (getItem(0).photos.isEmpty)
        photos.addAll(Url.spacexUpcomingScreen);
      else
        photos.addAll(getItem(0).photos.sublist(0, 3));
      photos.shuffle();
    }

    // Finished loading data
    loadingState(false);
  }
}

/// LAUNCH MODEL
/// Details about a specific launch, performed by a Falcon rocket,
/// including launch & landing pads, rocket & payload information...
class Launch {
  final int number;
  final String name,
      launchpadId,
      launchpadName,
      imageUrl,
      details,
      tentativePrecision;
  final List links, photos;
  final DateTime launchDate, staticFireDate;
  final bool launchSuccess, upcoming, tentativeTime;
  final Rocket rocket;
  final FailureDetails failureDetails;

  Launch({
    this.number,
    this.name,
    this.launchpadId,
    this.launchpadName,
    this.imageUrl,
    this.details,
    this.tentativePrecision,
    this.links,
    this.photos,
    this.launchDate,
    this.staticFireDate,
    this.launchSuccess,
    this.upcoming,
    this.tentativeTime,
    this.rocket,
    this.failureDetails,
  });

  factory Launch.fromJson(Map<String, dynamic> json) {
    return Launch(
      number: json['flight_number'],
      name: json['mission_name'],
      launchpadId: json['launch_site']['site_id'],
      launchpadName: json['launch_site']['site_name'],
      imageUrl: json['links']['mission_patch_small'],
      details: json['details'],
      tentativePrecision: json['tentative_max_precision'],
      links: [
        json['links']['video_link'],
        json['links']['reddit_campaign'],
        json['links']['presskit'],
        json['links']['article_link'],
      ],
      photos: json['links']['flickr_images'],
      launchDate: DateTime.parse(json['launch_date_utc']).toLocal(),
      staticFireDate: setStaticFireDate(json['static_fire_date_utc']),
      launchSuccess: json['launch_success'],
      upcoming: json['upcoming'],
      tentativeTime: json['is_tentative'],
      rocket: Rocket.fromJson(json['rocket']),
      failureDetails: setFailureDetails(json['launch_failure_details']),
    );
  }

  static DateTime setStaticFireDate(String date) {
    try {
      return DateTime.parse(date).toLocal();
    } catch (_) {
      return null;
    }
  }

  static FailureDetails setFailureDetails(Map<String, dynamic> failureDetails) {
    try {
      return FailureDetails.fromJson(failureDetails);
    } catch (_) {
      return null;
    }
  }

  String get getProfilePhoto => (hasImages) ? photos[0] : Url.defaultImage;

  String getPhoto(index) =>
      hasImages ? photos[index] : Url.spacexUpcomingScreen[index];

  int get getPhotosCount =>
      hasImages ? photos.length : Url.spacexUpcomingScreen.length;

  String get getRandomPhoto => photos[Random().nextInt(getPhotosCount)];

  bool get hasImages => photos.isNotEmpty;

  String get getNumber => '#$number';

  String get getImageUrl => imageUrl ?? Url.defaultImage;

  bool get hasImage => imageUrl != null;

  bool get hasVideo => links[0] != null;

  String get getVideo => links[0];

  String getDetails(context) =>
      details ??
      FlutterI18n.translate(context, 'spacex.launch.page.no_description');

  String get getLaunchDate {
    switch (tentativePrecision) {
      case 'hour':
        return '${DateFormat.yMMMMd().addPattern('Hm', ' · ').format(launchDate)} ${launchDate.timeZoneName}';
      case 'day':
        return 'NET ${DateFormat.yMMMMd().format(launchDate)}';
      case 'month':
        return 'NET ${DateFormat.yMMMM().format(launchDate)}';
      case 'quarter':
        return 'NET ${DateFormat.yQQQ().format(launchDate)}';
      case 'half':
        return 'NET H${launchDate.month < 7 ? 1 : 2} ${launchDate.year}';
      case 'year':
        return 'NET ${DateFormat.y().format(launchDate)}';
      default:
        return 'Date error';
    }
  }

  String get getUtcLaunchDate =>
      DateFormat.yMMMMd().addPattern('Hm', '  ·  ').format(launchDate.toUtc());

  String getStaticFireDate(context) => staticFireDate == null
      ? FlutterI18n.translate(context, 'spacex.other.unknown')
      : DateFormat.yMMMMd().format(staticFireDate);

  List<String> getEllipsis(context) => <String>[
        FlutterI18n.translate(context, 'spacex.launch.menu.reddit'),
        FlutterI18n.translate(context, 'spacex.launch.menu.press_kit'),
        FlutterI18n.translate(context, 'spacex.launch.menu.article')
      ];

  int getEllipsisIndex(context, url) => getEllipsis(context).indexOf(url) + 1;
}

/// FAILURE DETAILS MODEL
/// Auxiliar model to storage details about a launch failure
class FailureDetails {
  final num time, altitude;
  final String reason;

  FailureDetails({this.time, this.altitude, this.reason});

  factory FailureDetails.fromJson(Map<String, dynamic> json) {
    return FailureDetails(
      time: json['time'],
      altitude: json['altitude'],
      reason: json['reason'],
    );
  }

  String get getTime =>
      'T${time.isNegative ? '-' : '+'}${NumberFormat.decimalPattern().format(time.abs())} s';

  String getAltitude(context) => altitude == null
      ? FlutterI18n.translate(context, 'spacex.other.unknown')
      : '${NumberFormat.decimalPattern().format(altitude)} km';

  String get getReason => '${reason[0].toUpperCase()}${reason.substring(1)}';
}
