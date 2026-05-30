import 'package:flutter/material.dart';
import 'package:scout_obd/features/dashboard/state/dashboard_state.dart';

class HudLinkStatusIcon extends StatelessWidget {
  const HudLinkStatusIcon({super.key, required this.size, this.healthLevel});

  final double size;
  final HealthLevel? healthLevel;

  @override
  Widget build(BuildContext context) {
    final (IconData icon, Color base, Color glow) = switch (healthLevel) {
      HealthLevel.connected => (
        Icons.link_rounded,
        const Color(0xFF36FF7A), // Healthy Green
        const Color(0xFF00FF66),
      ),
      HealthLevel.noHeartbeat => (
        Icons.link_rounded,
        const Color(0xFFFFB347), // Warning Orange
        const Color(0xFFFF9900),
      ),
      HealthLevel.disconnected || null => (
        Icons.link_off_rounded,
        const Color(0xFFFF3B3B), // Error Red
        const Color(0xFFFF2A2A),
      ),
    };

    return Icon(
      icon,
      size: size,
      color: base,
    );
  }
}
