import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class TimeZoneReminder {
  final String id;
  final String zoneId;
  final String title;
  final DateTime triggerUtc;
  final bool isTriggered;

  const TimeZoneReminder({
    required this.id,
    required this.zoneId,
    required this.title,
    required this.triggerUtc,
    this.isTriggered = false,
  });

  TimeZoneReminder copyWith({
    bool? isTriggered,
  }) {
    return TimeZoneReminder(
      id: id,
      zoneId: zoneId,
      title: title,
      triggerUtc: triggerUtc,
      isTriggered: isTriggered ?? this.isTriggered,
    );
  }
}

class TimeZoneConverterState {
  final bool initialized;
  final List<String> allZoneIds;
  final List<String> selectedZoneIds;
  final Set<String> favoriteZoneIds;
  final String searchQuery;
  final String baseZoneId;
  final int baseMinutes;
  final List<TimeZoneReminder> reminders;

  const TimeZoneConverterState({
    this.initialized = false,
    this.allZoneIds = const [],
    this.selectedZoneIds = const ['Europe/Madrid', 'Europe/London', 'America/New_York'],
    this.favoriteZoneIds = const {},
    this.searchQuery = '',
    this.baseZoneId = 'Europe/Madrid',
    this.baseMinutes = 600,
    this.reminders = const [],
  });

  TimeZoneConverterState copyWith({
    bool? initialized,
    List<String>? allZoneIds,
    List<String>? selectedZoneIds,
    Set<String>? favoriteZoneIds,
    String? searchQuery,
    String? baseZoneId,
    int? baseMinutes,
    List<TimeZoneReminder>? reminders,
  }) {
    return TimeZoneConverterState(
      initialized: initialized ?? this.initialized,
      allZoneIds: allZoneIds ?? this.allZoneIds,
      selectedZoneIds: selectedZoneIds ?? this.selectedZoneIds,
      favoriteZoneIds: favoriteZoneIds ?? this.favoriteZoneIds,
      searchQuery: searchQuery ?? this.searchQuery,
      baseZoneId: baseZoneId ?? this.baseZoneId,
      baseMinutes: baseMinutes ?? this.baseMinutes,
      reminders: reminders ?? this.reminders,
    );
  }
}

class TimeZoneConverterController extends StateNotifier<TimeZoneConverterState> {
  TimeZoneConverterController() : super(const TimeZoneConverterState()) {
    initialize();
  }

  static bool _timezoneInitialized = false;

  static const _selectedKey = 'tz_selected_zone_ids';
  static const _favoriteKey = 'tz_favorite_zone_ids';
  static const _baseZoneKey = 'tz_base_zone_id';
  static const _baseMinutesKey = 'tz_base_minutes';

  Future<void> initialize() async {
    if (!_timezoneInitialized) {
      tz_data.initializeTimeZones();
      _timezoneInitialized = true;
    }

    final prefs = await SharedPreferences.getInstance();
    final allZoneIds = tz.timeZoneDatabase.locations.keys
        .where((id) => id.contains('/'))
        .toList()
      ..sort();

    final selected = prefs.getStringList(_selectedKey) ?? state.selectedZoneIds;
    final favorites = (prefs.getStringList(_favoriteKey) ?? <String>[]).toSet();
    final baseZone = prefs.getString(_baseZoneKey) ?? state.baseZoneId;
    final baseMinutes = prefs.getInt(_baseMinutesKey) ?? state.baseMinutes;

    final sanitizedSelected = selected.where(allZoneIds.contains).toSet().toList();
    final fallbackSelected = sanitizedSelected.isEmpty
        ? const ['Europe/Madrid', 'Europe/London', 'America/New_York']
        : sanitizedSelected;
    final sanitizedBase = allZoneIds.contains(baseZone) ? baseZone : fallbackSelected.first;

    state = state.copyWith(
      initialized: true,
      allZoneIds: allZoneIds,
      selectedZoneIds: fallbackSelected,
      favoriteZoneIds: favorites.where(allZoneIds.contains).toSet(),
      baseZoneId: sanitizedBase,
      baseMinutes: baseMinutes.clamp(0, 1439),
    );
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value.trim());
  }

  void addZone(String zoneId) {
    if (!state.allZoneIds.contains(zoneId) || state.selectedZoneIds.contains(zoneId)) return;
    final updated = [...state.selectedZoneIds, zoneId];
    state = state.copyWith(selectedZoneIds: updated);
    _persistSelected(updated);
  }

  void removeZone(String zoneId) {
    if (state.selectedZoneIds.length <= 1) return;
    final updated = state.selectedZoneIds.where((z) => z != zoneId).toList();
    final baseZone = updated.contains(state.baseZoneId) ? state.baseZoneId : updated.first;
    state = state.copyWith(selectedZoneIds: updated, baseZoneId: baseZone);
    _persistSelected(updated);
    _persistBaseZone(baseZone);
  }

  void toggleFavorite(String zoneId) {
    final updated = state.favoriteZoneIds.toSet();
    if (updated.contains(zoneId)) {
      updated.remove(zoneId);
    } else {
      updated.add(zoneId);
    }
    state = state.copyWith(favoriteZoneIds: updated);
    _persistFavorites(updated.toList());
  }

  void setBaseZone(String zoneId) {
    if (!state.selectedZoneIds.contains(zoneId)) return;
    state = state.copyWith(baseZoneId: zoneId);
    _persistBaseZone(zoneId);
  }

  void setBaseTime(TimeOfDay time) {
    final minutes = (time.hour * 60 + time.minute).clamp(0, 1439);
    state = state.copyWith(baseMinutes: minutes);
    _persistBaseMinutes(minutes);
  }

  void setBaseTimeFromSlider(double hourValue) {
    final hour = hourValue.round().clamp(0, 23);
    final minutes = hour * 60;
    state = state.copyWith(baseMinutes: minutes);
    _persistBaseMinutes(minutes);
  }

  void addReminder({
    required String zoneId,
    required String title,
    required TimeOfDay time,
  }) {
    final nowUtc = DateTime.now().toUtc();
    final zone = tz.getLocation(zoneId);
    final zonedNow = tz.TZDateTime.from(nowUtc, zone);
    var zonedTime = tz.TZDateTime(
      zone,
      zonedNow.year,
      zonedNow.month,
      zonedNow.day,
      time.hour,
      time.minute,
    );
    if (zonedTime.isBefore(zonedNow)) {
      zonedTime = zonedTime.add(const Duration(days: 1));
    }

    final reminder = TimeZoneReminder(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      zoneId: zoneId,
      title: title,
      triggerUtc: zonedTime.toUtc(),
    );
    state = state.copyWith(reminders: [...state.reminders, reminder]);
  }

  void markReminderTriggered(String id) {
    final updated = state.reminders
        .map((r) => r.id == id ? r.copyWith(isTriggered: true) : r)
        .toList();
    state = state.copyWith(reminders: updated);
  }

  void removeReminder(String id) {
    state = state.copyWith(
      reminders: state.reminders.where((r) => r.id != id).toList(),
    );
  }

  Future<void> _persistSelected(List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_selectedKey, value);
  }

  Future<void> _persistFavorites(List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoriteKey, value);
  }

  Future<void> _persistBaseZone(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_baseZoneKey, value);
  }

  Future<void> _persistBaseMinutes(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_baseMinutesKey, value);
  }
}

final timeZoneConverterProvider =
    StateNotifierProvider<TimeZoneConverterController, TimeZoneConverterState>(
  (ref) => TimeZoneConverterController(),
);
