# Climate

![logo](./git_resources/img/logo.png)

Climate is a Simple Weather app.

## Getting Started

This project is very simple and I did my best to add comments for almost every section to make it clear.

## To-Do

- [x] Support offline forecast.
- [x] Dark/Light Theme.
- [x] Handle exceptions.

## Development Cycles

- [x] Models
- [x] API
- [x] Database support
- [x] Shared Preference
- [x] bloc support
- [x] Setting page
- [x] Drawer
- [ ] Home page
- [ ] Separate widgets
- [ ] Performance check

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

```
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

Here are some screenshots of the app.

# Packages
intl: # ^0.16.1
http: # ^0.12.2
sembast: # ^2.4.7+7
path_provider: #  ^1.6.18
rxdart: # ^0.24.1
shared_preferences: # ^0.5.12
font_awesome_flutter: # ^8.8.1
weather_icons: # ^2.0.1
flutter_svg: # ^0.19.0
```yaml

```

# Licenses

- Climate information is from [metaweather][metaweather] API.

- UI is inspired from [Climate\_ Live Weather Forecasting App][ui] by [Harsha Mohan](https://www.behance.net/harshamohan)

[ui]: https://www.behance.net/gallery/91989981/Climate_-Live-Weather-Forecasting-App
[metaweather]: https://www.metaweather.com/api/
