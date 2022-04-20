# Monarch macOS



### Editing app icon
The Info.plist has a setting pointing to the app icon bundle, which is monarch_app.iconset.

If you need to edit the app icon, open that directory and you will see 10 pngs, one for each resolution
we should provide.

A simple way is to update the app icon is to get a 1024x1024 version of the new app icon (ideally with transparent background) 
and then make 10 copies of it, one for each resolution. Then using Preview you can resize each copy
to the resolution you need.

