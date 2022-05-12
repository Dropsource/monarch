class LogicalResolution {
  final double width;
  final double height;

  const LogicalResolution({required this.width, required this.height});

  static LogicalResolution fromStandardMap(Map<String, dynamic> args) {
    return LogicalResolution(width: args['width'], height: args['height']);
  }

  Map<String, double> toStandardMap() {
    return {'width': width, 'height': height};
  }
}
