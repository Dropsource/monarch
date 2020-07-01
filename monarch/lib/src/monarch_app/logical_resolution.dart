import 'channel_methods.dart';

/// Flutter uses logical pixels. Also called device-independent or
/// resolution-independent pixels.
///
/// By definition, there are roughly 38 logical pixels per centimeter,
/// or about 96 logical pixels per inch, of the physical display.
///
/// This class represents the logical resolution in terms of logical 
/// [width] and logical [height].
class LogicalResolution implements OutboundChannelArgument {
  final double width;
  final double height;

  const LogicalResolution({this.width, this.height});

  @override
  Map<String, double> toStandardMap() {
    return {
      'width': width,
      'height': height
    };
  }
}

