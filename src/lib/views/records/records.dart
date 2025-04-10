import 'package:flutter/material.dart';
import 'package:hci_air_quality/controllers/records_controller.dart';
import 'package:hci_air_quality/models/measure.dart';
import 'package:hci_air_quality/widgets/record.dart';

// inculare i grafici da qui
// https://github.com/deniscolak/smart-admin-dashboard/blob/master/lib/screens/dashboard/components/mini_information_widget.dart#L12

class RecordsView extends StatefulWidget {
  final RecordsController controller = RecordsController();

  RecordsView({super.key});

  @override
  _RecordsViewState createState() => _RecordsViewState();
}

class _RecordsViewState extends State<RecordsView> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ThemeData theme = Theme.of(context);

    return Scaffold(
        appBar: AppBar(
          elevation: 4,
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          title: const Text('Records'), // Mostra dove ti trovi
          leading: IconButton(
            icon:
                const Icon(Icons.arrow_back_ios), // Icona per tornare indietro
            onPressed: () =>
                Navigator.of(context).pop(), // Torna alla vista precedente
          ),
          actions: const [SizedBox(width: 4)],
        ),
        body: FutureBuilder(
            future: widget.controller.getHistory(),
            builder: ((context, snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              }
              List<Record> records = [];
              for (Measure measure in snapshot.data!) {
                records.add(Record(measure: measure));
              }

              records.sort((a, b) {
                return b.measure.time.compareTo(a.measure.time);
              });

              // printToConsole(line)

              return ListView(
                  padding: const EdgeInsets.all(16), children: records);
            })));
  }
}
