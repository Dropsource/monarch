import 'standard_mapper.dart';

/// Flutter uses logical pixels. Also called device-independent or
/// resolution-independent pixels.
///
/// By definition, there are roughly 38 logical pixels per centimeter,
/// or about 96 logical pixels per inch, of the physical display.
///
/// This class represents the logical resolution in terms of logical
/// [width] and logical [height].
class LogicalResolution {
  final double width;
  final double height;

  const LogicalResolution({required this.width, required this.height});
}

class LogicalResolutionMapper implements StandardMapper<LogicalResolution> {
  @override
  LogicalResolution fromStandardMap(Map<String, dynamic> args) =>
      LogicalResolution(width: args['width'], height: args['height']);

  @override
  Map<String, dynamic> toStandardMap(LogicalResolution obj) =>
      {'width': obj.width, 'height': obj.height};
}
