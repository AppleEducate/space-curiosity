import 'package:intl/intl.dart';

import 'vehicle.dart';

/// ROCKET INFO CLASS
/// This class represents a model of a rocket, like Falcon 9 or BFR, with
/// all its specifications in place.
class RocketInfo extends Vehicle {
  final int stages;
  final int launchCost;
  final int successRate;
  final DateTime firstLaunched;
  final num mass;
  final List<PayloadWeight> payloadWeights;
  final String engine;
  final List<int> engineConfiguration;
  final String fuel;
  final String oxidizer;
  final num engineThrustSea;
  final num engineThrustVacuum;
  final num thrustToWeight;

  RocketInfo({
    id,
    name,
    type,
    active,
    height,
    diameter,
    reusable,
    description,
    url,
    this.stages,
    this.launchCost,
    this.successRate,
    this.firstLaunched,
    this.mass,
    this.payloadWeights,
    this.engineConfiguration,
    this.engine,
    this.fuel,
    this.oxidizer,
    this.engineThrustSea,
    this.engineThrustVacuum,
    this.thrustToWeight,
  }) : super(
          id: id,
          name: name,
          type: type,
          active: active,
          height: height,
          diameter: diameter,
          reusable: reusable,
          description: description,
          url: url,
        );

  factory RocketInfo.fromJson(Map<String, dynamic> json) {
    return RocketInfo(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      active: json['active'],
      height: json['height']['meters'],
      diameter: json['diameter']['meters'],
      reusable: json['first_stage']['reusable'],
      description: json['description'],
      url: json['wikipedia'],
      stages: json['stages'],
      launchCost: json['cost_per_launch'],
      successRate: json['success_rate_pct'],
      firstLaunched: DateTime.parse(json['first_flight']),
      mass: json['mass']['kg'],
      payloadWeights: (json['payload_weights'] as List)
          .map((payloadWeight) => PayloadWeight.fromJson(payloadWeight))
          .toList(),
      engine: json['engines']['type'] + ' ' + json['engines']['version'],
      fuel: json['engines']['propellant_2'],
      oxidizer: json['engines']['propellant_1'],
      engineConfiguration: [
        json['first_stage']['engines'],
        json['second_stage']['engines'],
      ],
      engineThrustSea: json['engines']['thrust_sea_level']['kN'],
      engineThrustVacuum: json['engines']['thrust_vacuum']['kN'],
      thrustToWeight: json['engines']['thrust_to_weight'],
    );
  }

  String get subtitle => getLaunchTime;

  String get getStages => '$stages stages';

  String get getMass => '${NumberFormat.decimalPattern().format(mass)} kg';

  String get getHeight => '${NumberFormat.decimalPattern().format(height)} m';

  String get getDiameter =>
      '${NumberFormat.decimalPattern().format(diameter)} m';

  String get getSuccessRate =>
      '${NumberFormat.percentPattern().format(successRate / 100)}';

  String get getLaunchCost =>
      '${NumberFormat.currency(symbol: "\$", decimalDigits: 0).format(launchCost)}';

  String get getEngineThrustSea =>
      '${NumberFormat.decimalPattern().format(engineThrustSea)} kN';

  String get getEngineThrustVacuum =>
      '${NumberFormat.decimalPattern().format(engineThrustVacuum)} kN';

  String get getThrustToWeight => thrustToWeight == null
      ? 'Unknown'
      : NumberFormat.decimalPattern().format(thrustToWeight);

  String get getEngine => '${engine[0].toUpperCase()}${engine.substring(1)}';

  String get firstStageEngines => engineConfiguration[0].toString();

  String get secondStageEngines => engineConfiguration[1].toString();

  String get getFuel => '${fuel[0].toUpperCase()}${fuel.substring(1)}';

  String get getOxidizer =>
      '${oxidizer[0].toUpperCase()}${oxidizer.substring(1)}';

  String get getFirstLaunched => DateFormat.yMMMM().format(firstLaunched);

  String get getLaunchTime {
    if (!DateTime.now().isAfter(firstLaunched))
      return 'Scheduled to $getFirstLaunched';
    else
      return 'First launched on $getFirstLaunched';
  }
}

class PayloadWeight {
  final String name;
  final int mass;

  PayloadWeight({this.name, this.mass});

  factory PayloadWeight.fromJson(Map<String, dynamic> json) {
    return PayloadWeight(name: json['name'], mass: json['kg']);
  }

  String get getMass => '${NumberFormat.decimalPattern().format(mass)} kg';
}
