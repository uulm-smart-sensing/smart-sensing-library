git submodule update --init

Set-Location sensing-plugin
.\setup.ps1
Set-Location ..

(Invoke-WebRequest "https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh").content | bash

Remove-Item -path ./download/ -recurse

flutter pub get
flutter pub run build_runner build
