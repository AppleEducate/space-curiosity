import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';

import 'vehicle.dart';

/// CAPSULE INFO CLASS
/// This class represents a model of a capsule, like Dragon 1 or 2,,
/// with all its specifications.
class CapsuleInfo extends Vehicle {
  final num crew, launchMass, returnMass;
  final List<Thruster> thrusters;
  final bool reusable;

  CapsuleInfo({
    id,
    name,
    type,
    description,
    url,
    height,
    diameter,
    mass,
    active,
    firstFlight,
    photos,
    this.crew,
    this.launchMass,
    this.returnMass,
    this.thrusters,
    this.reusable,
  }) : super(
          id: id,
          name: name,
          type: type,
          description: description,
          url: url,
          height: height,
          diameter: diameter,
          mass: mass,
          active: active,
          firstFlight: firstFlight,
          photos: photos,
        );

  factory CapsuleInfo.fromJson(Map<String, dynamic> json) {
    return CapsuleInfo(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      description: json['description'],
      url: json['wikipedia'],
      height: json['height_w_trunk']['meters'],
      diameter: json['diameter']['meters'],
      mass: json['dry_mass_kg'],
      active: json['active'],
      firstFlight: DateTime.parse(json['first_flight']),
      photos: json['flickr_images'],
      crew: json['crew_capacity'],
      launchMass: json['launch_payload_mass']['kg'],
      returnMass: json['return_payload_mass']['kg'],
      thrusters: (json['thrusters'] as List)
          .map((thruster) => Thruster.fromJson(thruster))
          .toList(),
      reusable: true,
    );
  }

  String subtitle(context) => firstLaunched(context);

  String getCrew(context) => crew == 0
      ? FlutterI18n.translate(
          context,
          'spacex.vehicle.capsule.description.no_people',
        )
      : FlutterI18n.translate(
          context,
          'spacex.vehicle.capsule.description.people',
          {'people': crew.toString()},
        );

  String get getLaunchMass =>
      '${NumberFormat.decimalPattern().format(launchMass)} kg';

  String get getReturnMass =>
      '${NumberFormat.decimalPattern().format(returnMass)} kg';

  String get getThrusters => thrusters.length.toString();
}

class Thruster {
  final String name, fuel, oxidizer;
  final num amount, thrust;

  Thruster({
    this.name,
    this.fuel,
    this.oxidizer,
    this.amount,
    this.thrust,
  });

  factory Thruster.fromJson(Map<String, dynamic> json) {
    return Thruster(
      name: json['type'],
      fuel: json['fuel_2'],
      oxidizer: json['fuel_1'],
      amount: json['amount'],
      thrust: json['thrust']['kN'],
    );
  }

  String get getFuel => '${fuel[0].toUpperCase()}${fuel.substring(1)}';

  String get getOxidizer =>
      '${oxidizer[0].toUpperCase()}${oxidizer.substring(1)}';

  String get getAmount => amount.toString();

  String get getThrust => '${NumberFormat.decimalPattern().format(thrust)} kN';
}
