import 'dart:io';

import 'package:monarch_utils/log.dart';
import 'package:monarch_io_utils/monarch_io_utils.dart';

import '../utils/grep_exit_codes.dart' as grep_exit_codes;

const int defaultPortRangeStart = 64000;
const int defaultPortRangeEnd = 65000;

/// This class returns an available port we can use.
///
/// According the the wikipedia link below the ports we could freely
/// use are dynamic ports, which range from 49152–65535.
/// https://en.wikipedia.org/wiki/List_of_TCP_and_UDP_port_numbers#Dynamic,_private_or_ephemeral_ports
class PortPool with Log {
  final int portRangeStart;
  final int portRangeEnd;

  int _nextPort;

  PortPool(
      [this.portRangeStart = defaultPortRangeStart,
      this.portRangeEnd = defaultPortRangeEnd])
      : _nextPort = portRangeStart;

  int get nextPort {
    if (_nextPort > portRangeEnd) {
      log.severe('port range end reached, _nextPort was [$_nextPort]');
      throw StateError('port range end reached');
    }
    return _nextPort++;
  }

  Future<int> getNextAvailablePort() async {
    var port = nextPort;

    while (!await isPortAvailable(port)) {
      port = nextPort;
    }

    return port;
  }

  /// Returns true if the given [port] is being listened on by some process.
  ///
  /// We could use this grep command to find out which processes are listening
  /// on the ports we care about. Those processes could be useful if they are
  /// unused and we need to kill them.
  ///
  /// If the grep command finds a process listening on the given [port], it
  /// will return something like:
  ///
  /// flutter_t 89009 fertrig    6u  IPv4 0xb90ed891a596361b      0t0  TCP 127.0.0.1:64000 (LISTEN)
  ///
  /// The first token in the example above (flutter_t) is the command of the
  /// process, the second token in the example above (89009) is the process ID.
  Future<bool> isPortAvailable(int port) async {
    return futureForPlatform<bool>(
        macos: () => isMacOsPortAvailable(port),
        windows: () => isWindowsPortAvailable(port));
  }

  Future<bool> isMacOsPortAvailable(int port) async {
    var lsof = await Process.start('lsof', ['-nP', '-i4TCP:$port']);
    var grep = await Process.start('grep', ['LISTEN']);

    await lsof.stdout.pipe(grep.stdin);

    final exitCode = await grep.exitCode;

    if (exitCode == grep_exit_codes.oneOrMoreLinesSelected) {
      return false;
    } else if (exitCode == grep_exit_codes.noLinesSelected) {
      return true;
    } else {
      // @TODO: how to log grep errors here since the grep process has already exited
      throw 'Error while checking if port [$port] is available';
    }
  }

  Future<bool> isWindowsPortAvailable(int port) async {
    var netstat =
        NonInteractiveProcess('netstat', ['-ano'], workingDirectory: null);

    await netstat.run();

    log.info(netstat.getOutputMessage());

    var netstatOutput = netstat.stdout;

    // We could have used `find` command, but I had issues getting the pipe
    // to work on windows. There seems to be many issues with piping commands
    // in windows based on web searches.
    // Also, if the netstat command fails or exits unsuccessfully, it is still
    // likely that the port is available, as of 2020-10-01, we don't have any
    // code handling that failure. We will just let the stdout output code run.
    return !netstatOutput.contains(':$port');
  }
}
