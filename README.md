# Climate

![logo](./git_resources/img/logo.png)

Climate is a Simple Weather app.

## Getting Started

This project is very simple and I did my best to add comments for almost every section to make it clearer.You can download APK from release section.

## To-Do

- [x] Support offline forecast(sembast).
- [x] Dark/Light Theme(Rxdart).
- [x] Dynamic Theme based on the weather condition(Rxdart).
- [x] Handle exceptions.(a very simple one)
- [ ] Add a history page for forecasts on previous dates.

# Build

## **Linux**

First you need to fetch packages, so inside the folder where `pubspec.yaml` is located, run:

```bash
flutter packages get
```

Now run the below command to run the project on a connected device :

```bash
flutter run
```

Or run this to build it:

```bash
flutter build apk
```

Instead of `apk` you can use:

```text
  aar             Build a repository containing an AAR and a POM file.
  apk             Build an Android APK file from your app.
  appbundle       Build an Android App Bundle file from your app.
  bundle          Build the Flutter assets directory from your app.
  ios             Build an iOS application bundle (Mac OS X host only).
  ios-framework   Produces a .framework directory for a Flutter module and its
                  plugins for integration into existing, plain Xcode projects.
  linux           Build a Linux desktop application.
  web             Build a web application bundle.

```

For more info run:

```bash
flutter help
```

# Screenshot

Here are a few screenshots of the app.

<!-- Genymotion Google Nexus 6 -->
<!-- 768 X 1280 320 XHDPI-->
<!-- width Scaled down to 150 -->

![screenshot_01][screenshot_01]
![screenshot_02][screenshot_02]
![screenshot_03][screenshot_03]
![screenshot_04][screenshot_04]
![screenshot_05][screenshot_05]
![screenshot_06][screenshot_06]

# Packages

```yaml
intl: # ^0.16.1
http: # ^0.12.2
sembast: # ^2.4.7+7
path_provider: #  ^1.6.18
rxdart: # ^0.24.1
shared_preferences: # ^0.5.12
font_awesome_flutter: # ^8.8.1
weather_icons: # ^2.0.1
flutter_svg: # ^0.19.0
url_launcher: #^5.7.2
google_fonts: # ^1.1.0
```

# Licenses

- Climate information is from [metaweather][metaweather] API.
- UI is inspired from [Climate\_ Live Weather Forecasting App][ui] by [Harsha Mohan](https://www.behance.net/harshamohan).
- ![gauge][gaugepng] By [Freepik][freepik] from [flatIcon][flaticon], Here's the [url][gauge].
- ![weathercock][weathercocpng] By [Freepik][freepik] from [flatIcon][flaticon], Here's the [url][weathercock].
- ![crystal][crystalpng] By [Freepik][freepik] from [flatIcon][flaticon], Here's the [url][crystal].

<!-- ----------------------------- -->

[ui]: https://www.behance.net/gallery/91989981/Climate_-Live-Weather-Forecasting-App
[metaweather]: https://www.metaweather.com/api/

<!-- ------------ icons ---------------- -->

[freepik]: https://www.flaticon.com/authors/freepik
[flaticon]: https://www.flaticon.com/
[weathercock]: https://www.flaticon.com/free-icon/weathercock_2695810
[weathercocpng]: ./git_resources/img/weathercock.png
[gauge]: https://www.flaticon.com/free-icon/gauge_751928
[gaugepng]: ./git_resources/img/gauge.png
[crystal]: https://www.flaticon.com/free-icon/ball_1234647
[crystalpng]: ./git_resources/img/crystal.png

<!-- -------------- Screenshots ---------------- -->

[screenshot_01]: ./git_resources/img/screenshots/v1.0.0/screenshot_01.png
[screenshot_02]: ./git_resources/img/screenshots/v1.0.0/screenshot_02.png
[screenshot_03]: ./git_resources/img/screenshots/v1.0.0/screenshot_03.png
[screenshot_04]: ./git_resources/img/screenshots/v1.0.0/screenshot_04.png
[screenshot_05]: ./git_resources/img/screenshots/v1.0.0/screenshot_05.png
[screenshot_06]: ./git_resources/img/screenshots/v1.0.0/screenshot_06.png
