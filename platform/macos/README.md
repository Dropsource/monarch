# Monarch on macOS

This directory contains code for the Monarch Window Manager on macOS.

_The [Monarch Architecture](https://github.com/Dropsource/monarch/wiki/Monarch-Architecture)_ 
_document provides an overview of the Monarch Window Manager._

### Building
```
dart tools/build_platform.dart
```

### Debugging
You can use XCode to debug the Monarch macOS code. To debug with XCode you will have to
attach to a running instance of Monarch.

#### Steps to debug
1. Make your code changes
2. Run `dart tools/build_platform.dart`
3. Go to the flutter project you want to use to debug and then run `monarch run -v` on that project
4. Wait for the Monarch windows to show then go to `platform/macos/monarch_macos.xcodeproj`
5. From XCode, click Debug > Attach to Process by PID or Name, then set `Monarch` as the  PID or Process Name,
   then click Attach.

Your breakpoints should now hit as you exercise the Monarch app. 

#### Debugging the startup
The process above may not let you debug the macOS startup project which launches the 
Monarch windows. You may need to add a sleep timer to the entry function to give you 
enough time to attach to the Monarch app. 

### Editing app icon
The Info.plist has a setting pointing to the app icon bundle, which is monarch_app.iconset.

If you need to edit the app icon, open that directory and you will see 10 pngs, one for each resolution
we should provide.

A simple way is to update the app icon is to get a 1024x1024 version of the new app icon 
(ideally with transparent background) 
and then make 10 copies of it, one for each resolution. Then using Preview you can resize each copy
to the resolution you need.

### Bumping the version
To change the version of the Monarch macos app go to the XCode project, then click on `monarch_macos` on 
the top left, then click General, then in the Version field set the new version.
