# WIP

- Write a little bit about how the build works
- Then mention that there are visual studio solutions in each build/{flutter_sdk} directory
- That each solution includes references to the source files in the src directory
- There is only one src directory 
- How each flutter version has its own build directory and its own generated visual studio solution
- To debug or edit the code, open up the visual studio sln file
- Once the solution is open, make the project monarch_windows_app the startup project (Set as Startup Project)
- Document which arguments to pass for debug: 
  Debug > monarch_windows_app Debug Properties > Debugging > Command Arguments
  ```
  --controller-bundle C:\Users\fertrig\development\monarch_product\monarch_shift\out\monarch\bin\cache\monarch_ui\flutter_windows_3.0.1-stable\monarch_controller --project-bundle C:\Users\fertrig\development\scratch\morena\.monarch --log-level ALL
  ```
  OR: 
  run `monarch ron -v` on some scratch or test project, then open the log files, then search for
  `task_command="monarch_windows_app.exe`
  then copy all the arguments of that command, something like:
  ```
  --controller-bundle C:\Users\fertrig\development\monarch_product\monarch_shift\out\monarch\bin\cache\monarch_ui\flutter_windows_3.0.1-stable\monarch_controller --project-bundle C:\Users\fertrig\development\scratch\morena\.monarch --log-level ALL
  ```

- Should I list pre-requisites? Knowledge of C++, CMake and Visual Studio
- That the version number and app icon are taken from build_settings.yaml
- To sign commits on windows install gpg4win, which installs Kleopatra (the frontend of gpg)
  which runs the gpg agent, thus make sure Kleopatra is running when signing commits