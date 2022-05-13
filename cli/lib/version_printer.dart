import 'src/config/monarch_binaries.dart';
import 'src/config/internal_info.dart';

Future<void> printVersion() async {
  var internal = await readInternalFiles(defaultMonarchBinaries);
  print('''
Monarch version ${internal.binariesVersion}

Monarch modules:
- cli: ${internal.cliVersion}
- controller: ${internal.controllerVersion}
- platform_app: ${internal.platformAppVersion}

Revision:
${internal.binariesRevision}

''');
}
