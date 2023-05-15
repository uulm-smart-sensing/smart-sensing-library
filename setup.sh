bash <(curl -s https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh)

flutter pub get
flutter pub run build_runner build

rm -f -r download/

cd sensing-plugin
bash setup.sh
