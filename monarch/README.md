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

Then, you will run Monarch which will generate the code needed 
to display your stories in the Monarch desktop app. You can now see your 
stories in isolation, without all of your app's dependencies.

You can see your stories in the Monarch macOS or Windows desktop apps.

![](https://github.com/Dropsource/monarch/blob/master/monarch/docs/images/monarch_macos_long_title.png)
![](https://github.com/Dropsource/monarch/blob/master/monarch/docs/images/monarch_windows_long_title.png)

_This is the beta release of Monarch. We support flutter development on macOS and Windows._

## Installation

1. Add `monarch` and `build_runner` to your project dev_dependencies:
```yaml
dev_dependencies:
  monarch: ^0.0.32
  build_runner: ^1.10.3
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

4. Download the Monarch binaries, which include the Monarch CLI and desktop app. 
Download them into your directory of choice using `curl`, for example:

In macOS:
```shell
$ cd ~/development
$ curl -O https://s3.amazonaws.com/dropsource-monarch/dist/beta/macos/monarch_macos_0.2.0.zip
$ unzip monarch_macos_0.2.0.zip
```

In Windows:
```shell
cd development
curl -O https://s3.amazonaws.com/dropsource-monarch/dist/beta/windows/monarch_windows_0.2.1.zip
tar -x -f monarch_windows_0.2.1.zip
```

5. Add the monarch binaries to your path:

In macOS:
```shell
$ export PATH="$PATH:`pwd`/monarch/bin"
```

In Windows:
```shell
set PATH=%PATH%;C:\path\to\monarch\bin
```

This command sets your PATH variable for the current terminal window only. To permanently add Monarch to your path, see [Update your path](#update-your-path).

### Update your path
Follow these instructions to update your path variable permanently, which will let you run `monarch` from any terminal window.

In macOS:
1. Open your `rc` file, which may be ~/.bash_profile, ~/.bashrc or ~/.zshrc.
2. Add the following line and change [PATH_TO_MONARCH] to be the path where you unzipped Monarch:
```shell
export PATH="$PATH:[PATH_TO_MONARCH]/monarch/bin"
```
3. Run `source ~/.<rc file>` to refresh the current window, or open a new terminal window to automatically source the file.
4. Verify that the monarch/bin directory is now in your PATH by running:
```shell
$ echo $PATH
```
5. Verify that the monarch command is available by running:
```
$ monarch --version
```

In Windows:
1. From the Start search bar, enter ‘env’ and select Edit environment variables for your account.
2. Under User variables, look for an entry called Path, then append the full path of monarch\bin using ; as a separator from existing values.

## Usage

### Write stories
To write stories just create a `stories` directory at the top level of your 
project. Then start adding files that end in `*_stories.dart`.

You could also add stories inside your `lib` directory. The only requirement 
is that story files should end in `*_stories.dart`.

Stories are functions that return a `Widget`. Therefore, your stories code
doesn't require a dependency to Monarch. Also, since stories are plain functions,
they can be re-used from your widget tests.

### Run `monarch run` to see your stories
The `monarch run` command will prepare your stories so you can use them in the 
Monarch desktop app. Make sure you run it from inside your project directory.
```shell
$ monarch run
```
You should see Monarch working and eventually opening the Monarch app.

Once the app opens, you should see your stories listed on screen. You can 
select each story to see how it would render. You can also select different 
device resolutions, themes and locales.

You can now add more stories. As you add more stories, Monarch will 
automatically detect the changes and reload the stories in the app.

Monarch will generate a `.monarch` directory in your project. You
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
If you experience any issues while running monarch, you can run it in 
verbose mode.
```shell
$ monarch run -v
```

If you are running Monarch on Windows, you may experience some stability issues. 
Flutter desktop on Windows is still in alpha.

## Monarch CLI Commands
You can run `monarch -h` to see usage information.

### Update Monarch
To update Monarch just run this command:
```shell
$ monarch upgrade
```

