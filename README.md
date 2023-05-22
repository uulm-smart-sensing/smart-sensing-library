
<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a>
    <img src="https://cdn-images-1.medium.com/max/1200/1*5-aoK8IBmXve5whBQM90GA.png" alt="Logo" width="80" height="80">
  </a>
<h3 align="center">Smart Sensing Library</h3>
<a href="https://gitlab.uni-ulm.de/groups/se-anwendungsprojekt-22-23/-/wikis/home"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    [View Demo](./example/)


</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#development-setup">Development Setup</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Authors</a></li>
  </ol>
</details>



<!-- ABOUT THE PROJECT -->
## About The Project



Study apps can be helpful for the successful conduct of medical and psychological studies.
Especially the use of sensors, for example from smartphones or wearables, can provide useful data to support the study.

Therefore, the development of such apps should be as simple as possible in order to be able to use them without great effort.
That's why we develop a smart sensing library, which can be used to easily implement cross-platform apps with Flutter.

This library will be able to track sensors from the smartphone and some wearables, collect the sensor data and save it.
Additionally, it will be possible to either get live data or store and process the data.



### Built With

* [![Dart][Dart]][Dart]
* [![Kotlin][Kotlin]][Kotlin]
* [![Swift][Swift]][Swift]



<!-- GETTING STARTED -->
## Getting Started

1. Prerequisites:
   - Make sure you have Flutter and Dart installed on your development machine.
   - Check if you are using the latest version of the Flutter framework.

2. Clone the project:
   - Open the command line or a suitable terminal on your computer.
   - Navigate to the desired location for the project.
   - Clone the project repository from version control (e.g., Git) using the following command:
     ```
     git clone https://gitlab.uni-ulm.de/se-anwendungsprojekt-22-23/smart-sensing-library.git
     ```

3. Install dependencies:
   - Navigate to the root directory of the Flutter project.
   - Run the following command to install the required dependencies:
     ```
     flutter pub get
     ```
   - Execute setup script \
        On Windows run:

        ```powershell
        .\setup.ps1
        ```
        On Linux/macOS run:

        ```bash
        bash setup.sh
        ```

4. Configure emulator or device:
   - Ensure that an emulator or physical device is properly configured.
   - If using a physical device, connect your device via USB and enable developer mode.

5. Start the application:
   - Open the command line or terminal and navigate to the root directory of the Flutter project.
   - Execute the following command to start the Flutter application:
     ```
     flutter run
     ```

Note: Please ensure you have a stable internet connection to successfully download the dependencies during installation. Make sure all required SDKs and tools are up to date to ensure a smooth installation process.

<!-- Development setup-->
## Development setup

We use an `.editorconfig` file to define coding styles in this repo.
In order to apply to these coding style, following IDEs/editors need to be configured:
- VSCode: The plugin [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig) needs to be installed
- Android Studio: Enable EditorConfig support by navigating to `Settings` -> `Editor` -> `Code Style` and check `Enable EditorConfig support`


<!-- LICENSE -->
## License
[License](./LICENSE)

<!-- Authors -->
## Authors

- [Felix Schlegel](@npz16)
- [Hermann Fröhlich](@xhw97)
- [Florian Martin Gebhardt](@nck73)
- [Mukhtar Muse](@tca87)
- [Leonhard Alkewitz](@kjy97)

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[Dart]: https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white
[Kotlin]: https://img.shields.io/badge/kotlin-%237F52FF.svg?style=for-the-badge&logo=kotlin&logoColor=white
[Swift]: https://img.shields.io/badge/swift-F54A2A?style=for-the-badge&logo=swift&logoColor=white


