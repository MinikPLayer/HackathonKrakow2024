import 'package:flutter/material.dart';

enum Problems {
  overcrowded,
  late,
  smellsBad,
  noisy,
  dirty,
  emergency,
}

enum ProblemsSeverity {
  low,
  medium,
  high,
  critical,
}

class ReportedProblem {
  ReportedProblem({
    required this.problem,
    required this.severity,
  });

  final Problems problem;
  final ProblemsSeverity severity;

  static String severityToString(ProblemsSeverity s) {
    switch (s) {
      case ProblemsSeverity.low:
        return 'Low';
      case ProblemsSeverity.medium:
        return 'Medium';
      case ProblemsSeverity.high:
        return 'High';
      case ProblemsSeverity.critical:
        return 'Critical';
    }
  }

  static IconData severityToIcon(ProblemsSeverity severity) {
    switch (severity) {
      case ProblemsSeverity.low:
        return Icons.warning_amber_rounded;
      case ProblemsSeverity.medium:
        return Icons.warning;
      case ProblemsSeverity.high:
        return Icons.error;
      case ProblemsSeverity.critical:
        return Icons.dangerous;
    }
  }

  static Color severityToColor(ProblemsSeverity severity) {
    switch (severity) {
      case ProblemsSeverity.low:
        return Colors.yellow;
      case ProblemsSeverity.medium:
        return Colors.orange;
      case ProblemsSeverity.high:
        return Colors.red;
      case ProblemsSeverity.critical:
        return const Color.fromARGB(255, 142, 0, 0);
    }
  }

  static String problemToString(Problems problem) {
    switch (problem) {
      case Problems.overcrowded:
        return 'Overcrowded';
      case Problems.late:
        return 'Late';
      case Problems.smellsBad:
        return 'Smells bad';
      case Problems.noisy:
        return 'Noisy';
      case Problems.dirty:
        return 'Dirty';
      case Problems.emergency:
        return 'Emergency';
    }
  }
}
