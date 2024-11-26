import 'package:flutter/cupertino.dart';
import '../../../constants/http_service.dart';

class ControllerLogs extends StatefulWidget {
  const ControllerLogs({Key? key, required this.userId, required this.controllerId}) : super(key: key);
  final int userId;
  final int controllerId;

  @override
  State<ControllerLogs> createState() => _ControllerLogsState();
}

class _ControllerLogsState extends State<ControllerLogs> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
