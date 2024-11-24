import 'package:flutter/material.dart';
import 'package:hackathon_krakow_2024/src/models/connection.dart';
import 'package:hackathon_krakow_2024/src/models/reported_problem.dart';

class ReportProblemDialog extends StatefulWidget {
  const ReportProblemDialog({super.key, required this.connection});

  final Connection connection;

  @override
  State<ReportProblemDialog> createState() => _ReportProblemDialogState();
}

class _ReportProblemDialogState extends State<ReportProblemDialog> {
  Problems selectedProblem = Problems.overcrowded;
  ProblemsSeverity selectedSeverity = ProblemsSeverity.low;

  @override
  Widget build(BuildContext context) {
    var entries = Problems.values.map((problem) {
      return DropdownMenuItem(
        value: problem,
        child: Text(ReportedProblem.problemToString(problem)),
      );
    }).toList();

    var severities = ProblemsSeverity.values.map((severity) {
      return DropdownMenuItem(
        value: severity,
        child: Text(ReportedProblem.severityToString(severity),
            style: TextStyle(color: ReportedProblem.severityToColor(severity))),
      );
    }).toList();

    return AlertDialog(
      title: const Text('Report a problem'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButton(
            isExpanded: true,
            items: entries,
            value: selectedProblem,
            onChanged: (newElement) {
              setState(() {
                selectedProblem = newElement as Problems;
              });
            },
          ),
          DropdownButton(
            isExpanded: true,
            items: severities,
            value: selectedSeverity,
            onChanged: (newElememt) {
              setState(() {
                selectedSeverity = newElememt as ProblemsSeverity;
              });
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            widget.connection.addProblem(
              ReportedProblem(problem: selectedProblem, severity: selectedSeverity),
            );
            Navigator.pop(context);
          },
          child: const Text('Send'),
        ),
      ],
    );
  }
}
