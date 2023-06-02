## 2.1.1 - 2022-06-02
- Updated `defaultDeviceDefinition` to iPhone 14 data

## 2.1.0 - 2022-09-17
- Controller window close and minimize buttons
- Closing either window terminates the app
- Minimum size for controller window
- Use main UI thread for window observers
- Preview window restart

## 2.0.0 - 2022-05-09
- Most of the 1.x behavior has moved to the controller
- The management of native windows remains in this project
- Forwarding of controller and preview method channels

## 1.3.2 - 2021-12-14
- When the flutter window changes screens (i.e. monitors), force the flutter view 
  to resize its contents by sending a setActiveDevice channel message. Fixes #101.

## 1.3.1 - 2021-11-12
- Support hot reload: reset story
- Maintain scrolling position of story outline after reload

## 1.2.3
- New default device: iPhone 13

## 1.2.2
- Visual debugging flags
- Launch DevTools
- Change local distribution to dist_local directory
- Print messages with mac_app prefix

## 1.1.1 - 2021-08-13
- Move state of selected dock side to VerticalViewController to avoid accessing the 
  MainWindowController during startup which can fail in the automation server.

## 1.1.0 - 2021-08-03
- Dock story flutter window

## 1.0.0 - 2021-07-13
- Story scale: dropdown, selection, loading definitions, resizing window
