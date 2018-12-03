import 'dart:convert';
import 'dart:math';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../util/url.dart';
import '../querry_model.dart';
import 'info_capsule.dart';
import 'info_roadster.dart';
import 'info_rocket.dart';
import 'info_ship.dart';

/// VEHICLES MODEL
/// Model which storages information from all kind of vehicles.
class VehiclesModel extends QuerryModel {
  @override
  Future loadData() async {
    // Get items by http call
    final rocketsResponse = await http.get(Url.rocketList);
    final capsulesResponse = await http.get(Url.capsuleList);
    final roadsterResponse = await http.get(Url.roadsterPage);
    final shipsResponse = await http.get(Url.shipsList);

    List rocketsJson = json.decode(rocketsResponse.body);
    List capsulesJson = json.decode(capsulesResponse.body);
    List shipsJson = json.decode(shipsResponse.body);

    // Clear old data
    clearItems();

    // Add parsed item
    items.add(RoadsterInfo.fromJson(json.decode(roadsterResponse.body)));
    items.addAll(
      capsulesJson.map((capsule) => CapsuleInfo.fromJson(capsule)).toList(),
    );
    items.addAll(
      rocketsJson.map((rocket) => RocketInfo.fromJson(rocket)).toList(),
    );
    items.addAll(
      shipsJson.map((rocket) => ShipInfo.fromJson(rocket)).toList(),
    );

    // Add one photo per vehicle & shuffle them
    if (photos.isEmpty) {
      List<int> randomList = List<int>.generate(getSize, (index) => index);
      randomList
          .sublist(0, 5)
          .forEach((index) => photos.add(getItem(index).getRandomPhoto));
      photos.shuffle();
    }

    // Finished loading data
    loadingState(false);
  }
}

/// VEHICLE MODEL
/// Details about a specific SpaceX vehicle.
/// Vehicles are considered Roadster, Dragons & Falcons, and ships.
abstract class Vehicle {
  final String id, name, type, description, url;
  final num height, diameter, mass;
  final bool active;
  final DateTime firstFlight;
  final List photos;

  Vehicle({
    this.id,
    this.name,
    this.type,
    this.description,
    this.url,
    this.height,
    this.diameter,
    this.mass,
    this.active,
    this.firstFlight,
    this.photos,
  });

  String subtitle(context);

  String get getProfilePhoto => (hasImages) ? photos[0] : Url.defaultImage;

  int get getPhotosCount => photos.length;

  String get getRandomPhoto => photos[Random().nextInt(getPhotosCount)];

  String getPhoto(index) => photos[index];

  bool get hasImages => photos.isNotEmpty;

  String get getHeight => '${NumberFormat.decimalPattern().format(height)} m';

  String get getDiameter =>
      '${NumberFormat.decimalPattern().format(diameter)} m';

  String getMass(context) => mass == null
      ? FlutterI18n.translate(context, 'spacex.other.unknown')
      : '${NumberFormat.decimalPattern().format(mass)} kg';

  String get getFirstFlight => DateFormat.yMMMM().format(firstFlight);

  String get getFullFirstFlight => DateTime.now().isAfter(firstFlight)
      ? DateFormat.yMMMMd().format(firstFlight)
      : getFirstFlight;

  String firstLaunched(context) => FlutterI18n.translate(
        context,
        DateTime.now().isAfter(firstFlight)
            ? 'spacex.vehicle.subtitle.first_launched'
            : 'spacex.vehicle.subtitle.scheduled_launch',
        {'date': getFirstFlight},
      );
}
