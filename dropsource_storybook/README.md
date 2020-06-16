# Dropsource Storybook

Dropsource Storybook lets you generate stories for your widgets. Stories are 
just functions that return a widget.

For example, if you have a widget called `MyFancyCard` that takes in a `title`, 
then you could write these two stories:

```dart
Widget shortTitle() => MyFancyCard(
    title: 'A'
);

Widget longTitle() => MyFancyCard(
    title: 'Much longer title'
)
```

Dropsource Storybook will let you see those two stories in our storybook UI.

This is the alpha release of Dropsource Storybook. We only support flutter 
development on macOS for now.

## Installation
1. Add dropsource_storybook and build_runner to your project dev_dependencies:
```yaml
dev_dependencies:
  dropsource_storybook:
    git:
      url: git@github.com:Dropsource/dropsource_storybook.git
      path: dropsource_storybook
      ref: dropsource_storybook-0.0.17
  build_runner: ^1.7.1
```

2. Run `flutter pub get` on your project.

3. Create a build.yaml file at the top level of your project and add the 
following:
```yaml
targets:
  $default:
    sources:
      - lib/**
      - stories/**
```

4. To see your stories you need to run our storybook tools. Download them into
your directory of choice using `curl`, for example:

```
$ cd ~/development
$ curl -O https://dropsource-storybook.s3.amazonaws.com/dist/alpha/storybook_tools_0.0.25.zip
$ unzip storybook_tools_0.0.26.zip
```

## Example
There is an example project which shows how to write stories: 
[Example project](https://github.com/Dropsource/dropsource_storybook/tree/master/example).

## Usage

### Write stories
To write stories just create a `stories` directory at the top level of your 
project. Then start adding files that end in `*_stories.dart`.

You could also add stories inside your `lib` directory. The only requirement 
is that story files should end in `*_stories.dart`.

Stories files don't need a dependency on dropsource_storybook. Since stories 
are just functions that return a widget they can re-used from tests.


### Run the task runner to see your stories
The storybook_task_runner will prepare your stories so you can use them in the 
Storybook desktop app.

To run the storybook_task_runner, enter this command from inside your project 
directory.
```
$ ~/development/storybook_tools_0.0.25/storybook_task_runner
```
You should see the task runner working and eventually opening the Storybook app.

Once the app opens, you should see your stories listed on screen. You can 
select each story to see how it would render. You can also select different 
device resolutions and themes

You can now add more stories. As you add more stories, the task runner will 
automatically detect the changes and reload the stories in the app.

The task runner will generate a `.storybook` directory in your project. You
can gitignore that directory.
```
# in .gitignore
.storybook/
```


### Themes
Your stories can render using your app's themes. If you want see themes in 
storybook then you need to add the 
`package:dropsource_storybook_annotations` to your dependencies:
```yaml
dependencies:
  dropsource_storybook_annotations:
    git:
      url: git@github.com:Dropsource/dropsource_storybook.git
      path: dropsource_storybook_annotations
      ref: dropsource_storybook_annotations-0.0.5
``` 
Then, you can annotate your themes:
```dart
import 'package:dropsource_storybook_annotations/dropsource_storybook_annotations.dart';
...

@StorybookTheme('Fancy Theme')
final fancyTheme = ThemeData(...);
```
When you run the desktop app, you should be able to select your theme in the 
Theme dropdown.

## Troubleshooting
If you experience any issues while running the task runner, you can run it in 
verbose mode.
```
$ ~/path/to/storybook_task_runner --verbose
```

