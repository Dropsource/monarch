// ignore_for_file: constant_identifier_names

// Copyright (c) 2019, the Dart project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// [LogLevel]s to control logging output. Logging can be enabled to include all
/// levels above certain [LogLevel]. [LogLevel]s are ordered using an integer
/// value [LogLevel.value]. The predefined [LogLevel] constants below are sorted as
/// follows (in descending order): [LogLevel.SHOUT], [LogLevel.SEVERE],
/// [LogLevel.WARNING], [LogLevel.INFO], [LogLevel.CONFIG], [LogLevel.FINE], [LogLevel.FINER],
/// [LogLevel.FINEST], and [LogLevel.ALL].
///
/// We recommend using one of the predefined logging levels. If you define your
/// own level, make sure you use a value between those used in [LogLevel.ALL] and
/// [LogLevel.OFF].
class LogLevel implements Comparable<LogLevel> {
  final String name;

  /// Unique value for this level. Used to order levels, so filtering can
  /// exclude messages whose level is under certain value.
  final int value;

  const LogLevel(this.name, this.value);

  /// Special key to turn on logging for all levels ([value] = 0).
  static const LogLevel ALL = LogLevel('ALL', 0);

  /// Special key to turn off all logging ([value] = 2000).
  static const LogLevel OFF = LogLevel('OFF', 2000);

  /// Key for highly detailed tracing ([value] = 300).
  static const LogLevel FINEST = LogLevel('FINEST', 300);

  /// Key for fairly detailed tracing ([value] = 400).
  static const LogLevel FINER = LogLevel('FINER', 400);

  /// Key for tracing information ([value] = 500).
  static const LogLevel FINE = LogLevel('FINE', 500);

  /// Key for static configuration messages ([value] = 700).
  static const LogLevel CONFIG = LogLevel('CONFIG', 700);

  /// Key for informational messages ([value] = 800).
  static const LogLevel INFO = LogLevel('INFO', 800);

  /// Key for potential problems ([value] = 900).
  static const LogLevel WARNING = LogLevel('WARNING', 900);

  /// Key for serious failures ([value] = 1000).
  static const LogLevel SEVERE = LogLevel('SEVERE', 1000);

  /// Key for extra debugging loudness ([value] = 1200).
  static const LogLevel SHOUT = LogLevel('SHOUT', 1200);

  static const List<LogLevel> LEVELS = [
    ALL,
    FINEST,
    FINER,
    FINE,
    CONFIG,
    INFO,
    WARNING,
    SEVERE,
    SHOUT,
    OFF
  ];

  static LogLevel fromString(String? logLevelString, LogLevel orElseLogLevel) {
    return LEVELS.firstWhere((level) => level.name == logLevelString,
        orElse: () => orElseLogLevel);
  }

  @override
  bool operator ==(Object other) => other is LogLevel && value == other.value;

  bool operator <(LogLevel other) => value < other.value;

  bool operator <=(LogLevel other) => value <= other.value;

  bool operator >(LogLevel other) => value > other.value;

  bool operator >=(LogLevel other) => value >= other.value;

  @override
  int compareTo(LogLevel other) => value - other.value;

  @override
  int get hashCode => value;

  @override
  String toString() => name;
}
