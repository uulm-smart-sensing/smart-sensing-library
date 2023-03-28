flutter pub get
flutter pub run build_runner build

bash "<(curl -s https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh)"

Remove-Item -path ./download/ -recurse

cd sensing-plugin
./setup.sh
cd..
