import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:material_search/material_search.dart';

import '../../../models/rockets/info_vehicle.dart';
import '../details/capsule.dart';
import '../details/roadster.dart';
import '../details/rocket.dart';
import '../details/ship.dart';

/// SEARCH VEHICLES METHOD
/// Auxiliary method which helps filter vehicles by its name
searchVehicles(BuildContext context, List list) {
  return MaterialPageRoute<Vehicle>(
    builder: (context) => Material(
          child: MaterialSearch<Vehicle>(
            barBackgroundColor: Theme.of(context).primaryColor,
            iconColor: Colors.white,
            placeholder: FlutterI18n.translate(
              context,
              'spacex.other.tooltip.search',
            ),
            limit: list.length,
            results: list
                .map((item) => MaterialSearchResult<Vehicle>(
                      icon: Icons.search,
                      value: item,
                      text: item.name,
                    ))
                .toList(),
            filter: (dynamic value, String criteria) => value.name
                .toLowerCase()
                .trim()
                .contains(RegExp(r'' + criteria.toLowerCase().trim() + '')),
            onSelect: (dynamic vehicle) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => vehicle.type == 'rocket'
                        ? RocketPage(vehicle)
                        : vehicle.type == 'capsule'
                            ? CapsulePage(vehicle)
                            : vehicle.type == 'ship'
                                ? ShipPage(vehicle)
                                : RoadsterPage(vehicle),
                  ),
                ),
          ),
        ),
  );
}
