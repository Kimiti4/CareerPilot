import 'package:flutter_riverpod/flutter_riverpod.dart';

class DemoSettingsState {
  const DemoSettingsState({
    this.retainAudioTemporarily = true,
    this.lastClearTimestamp,
  });

  final bool retainAudioTemporarily;
  final DateTime? lastClearTimestamp;

  DemoSettingsState copyWith({
    bool? retainAudioTemporarily,
    DateTime? lastClearTimestamp,
  }) {
    return DemoSettingsState(
      retainAudioTemporarily:
          retainAudioTemporarily ?? this.retainAudioTemporarily,
      lastClearTimestamp: lastClearTimestamp ?? this.lastClearTimestamp,
    );
  }
}

class DemoSettingsNotifier extends Notifier<DemoSettingsState> {
  @override
  DemoSettingsState build() => const DemoSettingsState();

  void setRetainAudioTemporarily(bool value) {
    state = state.copyWith(retainAudioTemporarily: value);
  }

  void markLocalDataCleared() {
    state = state.copyWith(lastClearTimestamp: DateTime.now().toUtc());
  }
}

final demoSettingsProvider =
    NotifierProvider<DemoSettingsNotifier, DemoSettingsState>(
      DemoSettingsNotifier.new,
    );
