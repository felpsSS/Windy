import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:hci_air_quality/controllers/notifications_controller.dart';
import 'package:hci_air_quality/services/locator_service.dart';

import 'package:hci_air_quality/theme.dart';
import 'package:hci_air_quality/views/homeView/home_view.dart';
import 'package:hci_air_quality/views/records/records.dart';
import 'package:hci_air_quality/views/settings/settings.dart';

import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> requestPermissions() async {
  PermissionStatus storagePermission = await Permission.storage.status;
  if (!storagePermission.isGranted) {
    storagePermission = await Permission.storage.request();
  }
  print('Storage permission: ${storagePermission.isGranted}');
  PermissionStatus blePermission = await Permission.bluetooth.status;
  if (!blePermission.isGranted) {
    blePermission = await Permission.bluetooth.request();
  }
  print('BLE permission: ${blePermission.isGranted}');
  PermissionStatus notificationPermission = await Permission.notification.status;
  if (!notificationPermission.isGranted) {
    notificationPermission = await Permission.notification.request();
  }
  print('Notification permission: ${notificationPermission.isGranted}');
}


void main() {
  AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
            channelGroupKey: 'sound_channel_group',
            channelKey: 'sound_channel',
            channelName: 'Sound notifications',
            channelDescription: 'Notification channel with sound',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white),
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel',
            defaultColor: const Color(0xFF9D50DD),
            ledColor: Colors.white,
            playSound: false)
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
      
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  const MyApp({super.key});
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Smartlook smartlook = Smartlook.instance;

  @override
  void initState() {
    setup();

    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    super.initState();

    smartlook.start();
    // smartlook.log.enableLogging();
    //smartlook.preferences.setFrameRate(2);
    //smartlook.preferences.setRenderingMode(RenderingMode.native);
    smartlook.preferences.setProjectKey('76127eef8a221201ee445c22611c4c7e4da607ab');
  }

  @override
  Widget build(BuildContext context) {
    return SmartlookRecordingWidget(
        child: MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => HomeView(),
        '/settings': (context) => SettingView(),
        '/records': (context) => RecordsView(),
      },
      title: 'Air Quality App',
      theme: const MaterialTheme(TextTheme()).light(),
      darkTheme: const MaterialTheme(TextTheme()).dark(),
      navigatorKey: MyApp.navigatorKey,
    ));
  }

  @override
  void dispose() {
    smartlook.stop();
    super.dispose();
  }
}





/*
class MyApp extends StatelessWidget {

  const MyApp({super.key});

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Add the following line to set preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return SmartlookRecordingWidget(
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => HomeView(),
          '/settings': (context) => const SettingView(),
          '/records': (context) => RecordsView(),
        },
        title: 'Air Quality App',
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.green[500] ?? Colors.green),
          useMaterial3: true,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.green[500] ?? Colors.green,
              brightness: Brightness.dark),
        )
      )
    );
  }
}
*/
