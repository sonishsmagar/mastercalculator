// lib/core/providers.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Theme provider
final themeProvider = StateProvider<ThemeMode>((ref) => ThemeMode.dark);

// Navigation provider
final navigationProvider = StateProvider<int>((ref) => 0);

// Premium (remove ads) provider
final premiumProvider = StateProvider<bool>((ref) => false);
