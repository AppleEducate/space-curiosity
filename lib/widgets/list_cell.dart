import 'package:flutter/material.dart';

import '../utils/colors.dart';

/// LIST CELL CLASS
/// Widget used in vehicle & launch lists to display items
class ListCell extends StatelessWidget {
  final Widget leading;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback onTap;

  ListCell({
    this.leading,
    this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(16.0),
      leading: leading,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
        ],
      ),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 16.0)),
      trailing: trailing,
      onTap: onTap,
    );
  }
}

/// MISSION NUMBER CLASS
/// Trailing widget which displays the number of a specific mission.
class MissionNumber extends StatelessWidget {
  final String missionNumber;

  MissionNumber(this.missionNumber);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        missionNumber,
        style: TextStyle(fontSize: 18.0, color: lateralText),
        textAlign: TextAlign.center,
      ),
    );
  }
}

/// VEHICLE STATUS CLASS
/// Trailing widget which displays vehicle status with an icon.
class VehicleStatus extends StatelessWidget {
  final bool status;

  VehicleStatus(this.status);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Icon(
        status ? Icons.check_circle : Icons.cancel,
        color: lateralText,
      ),
    );
  }
}
