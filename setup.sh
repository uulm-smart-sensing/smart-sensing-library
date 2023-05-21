git submodule update --init

cd sensing-plugin
bash setup.sh

bash <(curl -s https://raw.githubusercontent.com/objectbox/objectbox-dart/main/install.sh)

rm -f -r download/

flutter pub get
flutter pub run build_runner build
