import 'package:flutter/services.dart';

import '../log/dropsource_log.dart';
import 'active_story.dart';
import 'channel_methods.dart';

final logger = Logger('ChannelMethodsReceiver');

void receiveChannelMethodCalls() {
  // logger.level = LogLevel.ALL;
  Channels.dropsourceStorybookChannel.setMethodCallHandler((MethodCall call) async {
    logger.info('channel method received: ${call.method}');

    try {
      return await _handler(call);
    } catch (e, s) {
      logger.severe(
          'exception in flutter runtime while handling channel method', e, s);
      return PlatformException(code: '001', message: e.toString());
    }
  });
}

Future<dynamic> _handler(MethodCall call) async {
  final Map args = call.arguments;

  switch (call.method) {
    case MethodNames.loadStory:
      final String storyKey = args['storyKey'];
      activeStory.setActiveStory(storyKey);
      break;

    default:
      // return exception to the platform side, do not throw
      return MissingPluginException('method ${call.method} not implemented');


    // case DefaultChannelMethods.settings:
    //   final String dartSdk = args['dartSdk'];
    //   final String evaluationTargetBuilderPath =
    //       args['evaluationTargetBuilderPath'];
    //   final String placeholderImagePath = args['placeholderImagePath'];
    //   final String widgetCatalogImagesPath = args['widgetCatalogImagesPath'];
    //   final bool printAnalysisServerMessages =
    //       args['printAnalysisServerMessages'];

    //   projectConfig.dartSdkPath = dartSdk;
    //   imageWidgetCreatorConfig.placeholderImagePath = placeholderImagePath;
    //   catalogConfig.imagesDirPath = widgetCatalogImagesPath;

    //   evaluationConfig.evaluationTargetBuilderPath =
    //       evaluationTargetBuilderPath;

    //   engine = ButterfreeEngine(dartSdk, catalogDefinitions);
    //   await engine.start(
    //       printAnalysisServerMessages: printAnalysisServerMessages);

    //   break;

    // case DefaultChannelMethods.loadProjectFolder:
    //   final String _projectDirectory = args['projectFolder'];

    //   final String projectDirectoryPath =
    //       normalizeAndAbsolute(_projectDirectory);

    //   await projectConfig.setProjectDirectoryPath(projectDirectoryPath);
    //   evaluationConfig.userFlutterExecutablePath =
    //       projectConfig.getFlutterSdkPath();

    //   imageWidgetCreatorConfig.projectDirectory = projectDirectoryPath;

    //   await engine.setupFlutterSourceManager(projectDirectoryPath);

    //   final evaluationManager = SourceFileEvaluationManager(
    //       evaluationConfig.userFlutterExecutablePath,
    //       projectDirectoryPath,
    //       engine.flutterSourceManager.projectFiles);

    //   final loaderManager = SourceFileLoaderManager(
    //       engine.flutterSourceManager, editorsManager, evaluationManager);

    //   editorsManager.setUp(engine.flutterSourceManager, catalogDefinitions,
    //       loaderManager, ProjectDefinition(projectDirectoryPath));

    //   handleKeyboardEvents();

    //   await evaluationManager.setUpProjectEvaluation();

    //   final watcher = ButterfreeWatcher(
    //       projectDirectoryPath, engine.flutterSourceManager, evaluationManager);
    //   engine.setUpDirectoryListener(watcher);
    //   _setUpFileListChangeListener(watcher);
    //   evaluationManager.setUpDirectoryListener(
    //       watcher, engine.flutterSourceManager);

    //   DefaultChannel.sendProjectFolderLoaded();
    //   DefaultChannel.sendProcessingChange(processing: false);
    //   break;

    // case DefaultChannelMethods.loadFile:
    //   final String file = args['file'];
    //   await editorsManager.ready;
    //   editorsManager.loadExistingFile(file);
    //   break;
  }
}