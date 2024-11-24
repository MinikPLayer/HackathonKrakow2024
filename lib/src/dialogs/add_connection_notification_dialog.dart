import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/models/connection.dart';
import 'package:hackathon_krakow_2024/src/view/home_view.dart';
import 'package:intl/intl.dart';

class AddConnectionNotificationDialog extends StatefulWidget {
  const AddConnectionNotificationDialog({super.key, required this.connection});

  final Connection connection;

  static List<DropdownMenuItem<Duration>> items = [
    DropdownMenuItem(value: const Duration(minutes: 5), child: Text('5 minutes')),
    DropdownMenuItem(value: const Duration(minutes: 10), child: Text('10 minutes')),
    DropdownMenuItem(value: const Duration(minutes: 15), child: Text('15 minutes')),
    DropdownMenuItem(value: const Duration(minutes: 30), child: Text('30 minutes')),
    DropdownMenuItem(value: const Duration(minutes: 60), child: Text('1 hour')),
  ];

  @override
  State<AddConnectionNotificationDialog> createState() => _AddConnectionNotificationDialogState();
}

class _AddConnectionNotificationDialogState extends State<AddConnectionNotificationDialog> {
  Duration? selectedDuration;
  String errorText = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Set connection notification'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (errorText != '')
            Text(
              errorText,
              style: const TextStyle(color: Colors.red),
            ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Notify time: '),
              Expanded(
                child: DropdownButton(
                  isExpanded: true,
                  value: selectedDuration,
                  items: AddConnectionNotificationDialog.items,
                  onChanged: (v) {
                    setState(() {
                      selectedDuration = v;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (selectedDuration == null) {
              setState(() {
                errorText = 'Please select a time';
              });
              return;
            }

            HomeView.showToast(context,
                'Notification set for ${widget.connection.from.name} to ${widget.connection.to.name} ${selectedDuration!.inMinutes}min before departure at ${DateFormat.Hm().format(widget.connection.departureTime)}');
            Navigator.of(context).pop();
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
