import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the dashboard selected tab index
final dashboardIndexProvider = StateProvider<int>((ref) => 0);
