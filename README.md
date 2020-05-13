# Dropsource Storybook

This is the alpha release of Dropsource Storybook.

### Requirements
- macOS
- The master channel of flutter should be installed on your computer
- The project you want to run storybook on should be using flutter master channel

### Installation
Add dropsource_storybook to your project dependencies:
```
dependencies:
  dropsource_storybook:
    git:
      url: git@github.com:Dropsource/dropsource_storybook.git
      ref: v0.0.2
  build_runner: ^1.7.1
```
It requires build_runner, make sure to add it.

Create a build.yaml file at the top level of your project and add the following:
```
targets:
  $default:
    sources:
      - lib/**
      - stories/**
```

Outside of your project directory, create a `storybook_tools` directory. Then, download the storybook tools to that directory.
```
$ cd path/to/storybook_tools
$ curl -O https://dropsource-storybook.s3.amazonaws.com/dist/alpha/storybook_tools_0.0.2.zip
$ unzip storybook_tools_0.0.2.zip
```

### Usage

#### Write stories
To write stories just create a `stories` directory at the top level of your project. Then start adding files that end in `*.stories.dart`.

For example, assuming your project has a widget called `MyFancyCard` inside the file `lib/my_fancy_card.dart`. Then you can create stories for it inside the file `stories/my_fancy_card.stories.dart`.

```
// stories/my_fancy_card.stories.dart

import 'package:flutter/material.dart';
import 'package:my_package/my_fancy_card.dart';

Widget foo() => MyFancyCard(
    title: 'foo for life', 
    icon: Icon(Icons.people));

Widget color_icon() => MyFancyCard(
    title: 'with some color', 
    icon: Icon(Icons.people, color: Colors.red));

Widget empties() => MyFancyCard(
    title: '', 
    icon: null);

```
Notice how you only need to import flutter and my_fancy_card.dart. Also, the `*.stories.dart` file can have any name, it just needs to end in `.stories.dart`.

Stories are just functions that return a `Widget`.

#### Launch the Storybook desktop app
Once you have at least one story ready, you can fire up the storybook_task_runner. The task runner will prepare your stories so you can use them in the Storybook desktop app.

To run the storybook_task_runner, enter this command from inside your project directory.
```
$ path/to/storybook_tools/storybook_tools_0.0.2/storybook_task_runner
```
You should see the task runner working and eventually opening the Storybook app.

Once the app opens, you should see your stories listed on screen. You can select each story to see how it would render. You can also select different device resolutions.

You can now add more stories. As you add more stories, the task runner will automatically detect the changes and reload the stories in the app.


### Troubleshooting
If you experience any issues while running the stories. Please run the task runner with logging turned on.
```
$ path/to/storybook_tools/storybook_tools_0.0.2/storybook_task_runner --log-level ALL
```


### TODOs

- [ ] Add minimum macOS version required, or at least the ones we have tested it on
- [ ] Test installation with dev_dependencies
- [ ] Make sure this README is easy enough to understand, it might need more work

