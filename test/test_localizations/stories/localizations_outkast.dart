import 'package:monarch_annotations/monarch_annotations.dart';
import 'package:test_localizations/localizations.dart';

/*
[WARNING] monarch:meta_localizations_builder on stories/localizations_outkast.dart:
══╡ MONARCH WARNING ╞═══════════════════════════════════════════════════════════════════════════════
`MonarchLocalizations` annotation on library stories/localizations_outkast.dart will not be used.
The `MonarchLocalizations` annotation should be used in libraries inside the lib directory.
════════════════════════════════════════════════════════════════════════════════════════════════════
*/
@MonarchLocalizations([MonarchLocale('xx', 'XX')])
const outkastDelegate = SampleLocalizationsDelegate(
  supportedLocales: [english],
  defaultLocale: english,
);
