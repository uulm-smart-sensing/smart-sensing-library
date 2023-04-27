flutter pub get
flutter pub run build_runner build

(Invoke-WebRequest "https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh").content | bash

Remove-Item -path ./download/ -recurse

Set-Location sensing-plugin
.\setup.ps1
Set-Location ..
