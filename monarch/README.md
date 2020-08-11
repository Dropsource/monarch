# Monarch
Build high-quality flutter widgets faster.

Monarch is a tool for developing widgets in isolation. It makes building 
beautiful widgets a more pleasant and faster experience. It is inspired by 
[Storybook](https://storybook.js.org/).

Monarch allows you to browse a widget library, view the different states of 
each widget, and interactively develop widgets.

## Workflow
First, you write stories for the widgets you want to test. A story is a 
function that returns a widget in a specific state. For example, if you have 
a widget called `MyFancyCard` that takes in a `title`, then you could write 
these two stories:

```
Widget shortTitle() => MyFancyCard(title: 'A');

Widget standardTitle() => MyFancyCard(title: 'A standard title');

Widget longTitle() => MyFancyCard(title: 'Some long title lorem ipsum dolor sit amet, consectetur adipiscing elit');
```

Then, you will run the Monarch task runner which will generate the code needed 
to display your stories in the Monarch desktop app. You can now see your 
stories in isolation, without all of you app's dependencies.

![](https://github.com/Dropsource/monarch/blob/master/monarch/docs/images/monarch_long_title.png)

_This is the alpha release of Monarch. We only support flutter development on macOS for now._

## Installation
1. Add `monarch` and `build_runner` to your project dev_dependencies:
```yaml
dev_dependencies:
  monarch: ^0.0.30
  build_runner: ^1.7.1
```

2. Run `flutter pub get` on your project.

3. Create a build.yaml file at the top level of your project and add the 
following:
```yaml
targets:
  $default:
    sources:
      - $package$
      - lib/**
      - stories/**
```

4. Download the Monarch tools, which include the task runner and desktop app. 
Download them into your directory of choice using `curl`, for example:

```
$ cd ~/development
$ curl -O https://dropsource-monarch.s3.amazonaws.com/dist/alpha/monarch_tools_0.0.53.zip
$ unzip monarch_tools_0.0.53.zip
```

## Usage

### Write stories
To write stories just create a `stories` directory at the top level of your 
project. Then start adding files that end in `*_stories.dart`.

You could also add stories inside your `lib` directory. The only requirement 
is that story files should end in `*_stories.dart`.

Stories are functions that return a `Widget`. Therefore, your stories code
doesn't require a dependency to Monarch. Also, since stories are plain functions,
they can be re-used from your widget tests.

### Run the task runner to see your stories
The monarch_task_runner will prepare your stories so you can use them in the 
Monarch desktop app.

To run the monarch_task_runner, enter this command from inside your project 
directory.
```
$ ~/development/monarch_tools/monarch_task_runner
```
You should see the task runner working and eventually opening the Monarch app.

Once the app opens, you should see your stories listed on screen. You can 
select each story to see how it would render. You can also select different 
device resolutions, themes and locales.

You can now add more stories. As you add more stories, the task runner will 
automatically detect the changes and reload the stories in the app.

The task runner will generate a `.monarch` directory in your project. You
can gitignore that directory.
```
# in .gitignore
.monarch/
```


### Themes
Your stories can render using your app's themes. If you want to see themes in 
Monarch then you need to add the 
`package:monarch_annotations` to your dependencies:
```yaml
dependencies:
  monarch_annotations: ^0.0.12
``` 
Then, you can annotate your themes:
```dart
import 'package:monarch_annotations/monarch_annotations.dart';
...

@MonarchTheme('Fancy Theme')
final fancyTheme = ThemeData(...);
```
When you run the Monarch app, you should be able to select your theme in the 
Theme dropdown.


### Internationalization (or Localizations)
If your application is internationalized (or localized), you can render your stories using the locales 
you have declared in code.

First, make sure to add the `package:monarch_annotations` to your dependencies:
```yaml
dependencies:
  monarch_annotations: ^0.0.12
``` 
Then, you can annotate your app-specific localizations delegate:
```dart
import 'package:monarch_annotations/monarch_annotations.dart';
...

class MyLocalizationsDelegate extends LocalizationsDelegate<MyLocalizations> {...}

@MonarchLocalizations([MonarchLocale('en', 'US'), MonarchLocale('es')])
const myLocalizationsDelegate = MyLocalizationsDelegate();
```
In the example above, the locales `en-US` and `es` will display in the Monarch app.

When you run the Monarch app, you should be able to select the locales you want
to use from the Locale dropdown.


## Troubleshooting
If you experience any issues while running the task runner, you can run it in 
verbose mode.
```
$ ~/path/to/monarch_task_runner --verbose
```

