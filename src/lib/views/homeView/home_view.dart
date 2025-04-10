import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hci_air_quality/controllers/device_controller.dart';
import 'package:hci_air_quality/controllers/home_view_controller.dart';
import 'package:hci_air_quality/views/homeView/battery.dart';
import 'package:hci_air_quality/views/homeView/side_bar.dart';
import 'package:hci_air_quality/views/homeView/summary.dart';
import 'package:hci_air_quality/widgets/bar_chart.dart';

class HomeView extends StatefulWidget {
  final HomeViewController controller = HomeViewController();

  HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  bool isfetching = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.controller.dispose();
    super.dispose();
    debugPrint("HomeView disposed");
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    debugPrint("AppState: $state");
    if (state == AppLifecycleState.detached) {
      widget.controller.deviceController.bt.disconnect().then((status) {
        if (status == 0) {
          debugPrint("Bluetooth disconnected");
        } else if (status == -1) {
          debugPrint("Disconnect error");
        } else {
          debugPrint("Nothing to disconnect");
        }
      }).whenComplete(() {
        super.didChangeAppLifecycleState(state);
      });
      //dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        elevation: 8,
        onPressed: () async {
              if (!widget.controller.isBusy) {
                setState(() {
                  isfetching = true;
                  _scrollController.animateTo(0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.decelerate);
                });

                await widget.controller.fetchAirQualityData();
                Timer(const Duration(seconds: 1), () {
                  setState(() {
                    isfetching = false;
                  });
                });
              }
            },
        child: const Icon(
          Icons.air,
          size: 36,
        ),
      ),
      appBar: AppBar(
        elevation: 4,
        title: const Text('Home'),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: [
          ListenableBuilder(
              listenable: widget.controller.storageController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: 3.1415 / 2,
                  child: BatteryIcon(
                      icon: Icons.battery_full,
                      size: 30,
                      percentage:
                          widget.controller.deviceController.batteryPercentage),
                );
              }),
          ListenableBuilder(
            listenable: widget.controller.deviceController.bt,
            builder: (context, child) {
              return IconButton(
                icon: Icon(
                  widget.controller.isConnected()
                      ? Icons.bluetooth_connected
                      : Icons.bluetooth_disabled,
                  color: widget.controller.isConnected() ? Colors.blue : null,
                ),
                onPressed: () async {
                  if (widget.controller.isBusy) {
                    return;
                  }
                  setState(() {
                    isfetching = true;
                    _scrollController.animateTo(0,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.decelerate);
                  });
                  var status = await widget.controller.scanBluetoothDevices();
              
                  if (status == 0) {
                    launchNotification("Connection established!",
                        "You are now connected to the device, and can monitor the air quality.");
                    await widget.controller.fetchAirQualityData();
                  } else {
                    launchNotification("Connection failed!",
                        "Please make sure the device is turned on and nearby.");
                  }
                  Timer(const Duration(seconds: 1), () {
                    setState(() {
                      isfetching = false;
                    });
                  });
                },
              );
            }
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Metrics Information'),
                    content: const Text(
                        'Making use of the companion device, this application uses two sensor metrics, from which it calculates an overall air quality index.\r\n\r\nCO2: contrary to popular belief, it is a common indoor air pollutant.\r\nTVOC: Total Volatile Organic Compounds, emitted as gases from certain solids or liquids.\r\n\r\nMeasures are given in parts per million (ppm) and parts per billion (ppb).'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Close'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          const SizedBox(width: 4)
        ],
      ),
      drawer: SideBar(),
      body: ListenableBuilder(
          listenable: widget.controller.storageController,
          builder: (context, child) {
            return widget.controller.storageController.history == null
                ? const Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Loading data...')
                    ],
                  ))
                : ListView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(bottom: 80),
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: isfetching
                            ? const Center(child: CircularProgressIndicator())
                            : AlternativeView(
                                lastMeasure: widget.controller.storageController
                                        .history!.isNotEmpty
                                    ? widget.controller.storageController
                                        .history!.last
                                    : null,
                              ),
                      ),
                      Card(
                        elevation: 2,
                        child: CustomBarChart(
                          history: widget.controller.storageController.history!,
                          mode: 'co2',
                        ),
                      ),
                      Card(
                        elevation: 2,
                        child: CustomBarChart(
                          history: widget.controller.storageController.history!,
                          mode: 'tvoc',
                        ),
                      ),
                      Card(
                        elevation: 2,
                        child: CustomBarChart(
                          history: widget.controller.storageController.history!,
                          mode: 'aq',
                        ),
                      )
                    ],
                  );
          }),
    );
  }
}
