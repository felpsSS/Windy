import 'package:flutter/material.dart';
import 'package:hci_air_quality/controllers/settings_controller.dart';
//import 'package:hci_air_quality/services/notifications_service.dart';

class SettingView extends StatefulWidget {
  final SettingController controller = SettingController();

  SettingView({super.key});

  @override
  _SettingViewState createState() => _SettingViewState();
}

String rate2String(int rate) {
  switch (rate) {
    case 1:
      return '1 minute';
    case 2:
      return '5 minutes';
    case 3:
      return '10 minutes';
    case 4:
      return '30 minutes';
    case 5:
      return '1 hour';
    default:
      return '2 hours';
  }
}

int rate2Seconds(int rate) {
  switch (rate) {
    case 1:
      return 60;
    case 2:
      return 300;
    case 3:
      return 600;
    case 4:
      return 1800;
    case 5:
      return 3600;
    default:
      return 7200;
  }
}

class _SettingViewState extends State<SettingView> {
  @override
  Widget build(BuildContext context) {
    bool _notifications =
        widget.controller.storage.prefs?.getBool('notifications') ?? false;
    bool _sound = widget.controller.storage.prefs?.getBool('sound') ?? false;
    double _updateRate =
        widget.controller.storage.prefs?.getInt('update_rate')!.toDouble() ?? 1;

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: const Text('Settings'), // Mostra dove ti trovi
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios), // Icona per tornare indietro
          onPressed: () =>
              Navigator.of(context).pop(), // Torna alla vista precedente
        ),
        actions: const [SizedBox(width: 4)],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(
          child: Column(
            children: [
              ListTile(
                title: Text(
                    'Update rate (${rate2String(widget.controller.storage.prefs?.getInt('update_rate') ?? 1)}):'),
                subtitle:
                    const Text('\tHow often the app should poll for data'),
              ),
              Slider(
                value: _updateRate,
                min: 1,
                max: 6,
                divisions: 5,
                label: rate2String(_updateRate.toInt()),
                onChanged: (double value) {
                  setState(() {
                    _updateRate = value;
                    widget.controller.storage
                        .changeUpdateRate(_updateRate.toInt());
                  });
                },
              )
            ],
          ),
        ),
        Card(
            child: Column(
          children: [
            SwitchListTile(
              title: const Text('Notifications'),
              subtitle: const Text('Enable notifications'),
              value: _notifications,
              onChanged: (bool value) {
                setState(() {
                  _notifications = value;
                  widget.controller.storage.prefs?.setBool('notifications', _notifications);
                  if (!value) {
                    _sound = false;
                    widget.controller.storage.prefs?.setBool('sound', _sound);
                  }
                });
              },
            ),
            SwitchListTile(
              title: const Text('Sound'),
              value: _sound,
              onChanged: (bool value) {
                setState(() {
                  _sound = value && _notifications;
                  widget.controller.storage.prefs?.setBool('sound', _sound);
                });
              },
            ),
          ],
        )),
        Card(
          child: Column(
            children: [
              ListTile(
                  title: const Text('Reset Alerts'),
                  subtitle: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll<Color>(Theme.of(context).colorScheme.secondaryContainer)),
                    onPressed: () {
                      widget.controller.storage.prefs?.remove('last_alert');
                      widget.controller.storage.prefs?.remove('last_reassurance');
                      setState(() {});
                    },
                    child: const Text("Reset"),
                  )),
              ListTile(
                subtitle: Text(
                    "By default alert will be sent every 24hs only, to avoid spamming.\r\nLast alert has been sent on: ${GetLatestAlert()}"),
              ),
            ],
          ),
        )
        // SwitchListTile(
        //   title: const Text('Vibration'),
        //   value: _vibration,
        //   onChanged: (bool value) {
        //     setState(() {
        //       _vibration = value && _notifications;
        //     });
        //   },
        // ),
      ]),
    );
  }

  String GetLatestAlert() {
    String? alert = widget.controller.storage.prefs?.getString('last_alert');
    String? reassurance = widget.controller.storage.prefs?.getString('last_reassurance');
    if (alert == null && reassurance == null) {
      return 'never';
    }
    if (alert == null) {
      return DateFormatter(reassurance);
    }
    if (reassurance == null) {
      return DateFormatter(alert);
    }
    if (DateTime.parse(alert).isAfter(DateTime.parse(reassurance))) {
      return DateFormatter(alert);
    }
    return DateFormatter(reassurance);
  }

  String DateFormatter(String? date) {
    if (date == null) {
      return 'never';
    }
    var dater = DateTime.parse(date);
    return '${dater.day}/${dater.month}/${dater.year} ${dater.hour}:${dater.minute}';
  }
}
