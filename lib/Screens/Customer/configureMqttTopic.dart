import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../constants/MQTTManager.dart';
import '../../state_management/MqttPayloadProvider.dart';



class ConfigureMqtt extends StatefulWidget {
  final String deviceID;

  const ConfigureMqtt({Key? key, required this.deviceID}) : super(key: key);

  @override
  _ConfigureMqttState createState() => _ConfigureMqttState();
}

class _ConfigureMqttState extends State<ConfigureMqtt> {
  late MqttPayloadProvider mqttPayloadProvider;
  List<Map<String, dynamic>> configs = [];
  int? selectedIndex;
  bool isLoading = true;
  String errorMessage = '';
  String? formattedConfig;

  @override
  void initState() {
    super.initState();
    mqttPayloadProvider = Provider.of<MqttPayloadProvider>(context, listen: false);
    fetchData();
  }

  Future<void> fetchData() async {
    final url = Uri.parse('http://13.235.254.21:9000/getConfigs');

    try {
      final response = await http.get(url, headers: {'Content-Type': 'application/json'});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> rawConfigs = data['data'];
        configs = rawConfigs.cast<Map<String, dynamic>>();

        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load configs: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: $e';
        isLoading = false;
      });
    }
  }

  String formatConfig(Map<String, dynamic> config) {


      return '${config['MQTT_IP'] ?? '-'},'
          '${config['MQTT_USER_NAME'] ?? '-'},'
          '${config['MQTT_PASSWORD'] ?? '-'},'
          '${config['MQTT_PORT'] ?? '-'},'
          '${config['HTTP_URL'] ?? '-'},'
          '${config['STATIC_IP'] ?? '-'},'
          '${config['SUBNET_MASK'] ?? '-'},'
          '${config['DEFAULT_GATEWAY'] ?? '-'},'
          '${config['DNS_SERVER'] ?? '-'},'
          '${config['FTP_IP'] ?? '-'},'
          '${config['FTP_USER_NAME'] ?? '-'},'
          '${config['FTP_PASSWORD'] ?? '-'},'
          '${config['FTP_PORT'] ?? '-'},'
          '${config['MQTT_FRONTEND_TOPIC'] ?? '-'},'
          '${config['MQTT_HARDWARE_TOPIC'] ?? '-'},'
          '${config['MQTT_SERVER_TOPIC'] ?? '-'}';
    // } else {
    //   return '${config['MQTT_IP'] ?? '-'},'
    //       '${config['MQTT_USER_NAME'] ?? '-'},'
    //       '${config['MQTT_PASSWORD'] ?? '-'},'
    //       '${config['MQTT_PORT'] ?? '-'},'
    //       '${config['HTTP_URL'] ?? '-'},'
    //       '${config['STATIC_IP'] ?? '-'},'
    //       '${config['SUBNET_MASK'] ?? '-'},'
    //       '${config['DEFAULT_GATEWAY'] ?? '-'},'
    //       '${config['DNS_SERVER'] ?? '-'},'
    //       '${config['FTP_IP'] ?? '-'},'
    //       '${config['FTP_USER_NAME'] ?? '-'},'
    //       '${config['FTP_PASSWORD'] ?? '-'},'
    //       '${config['FTP_PORT'] ?? '-'},'
    //       '${config['MQTT_FRONTEND_TOPIC'] ?? '-'},'
    //       '${config['MQTT_HARDWARE_TOPIC'] ?? '-'},'
    //       '${config['MQTT_SERVER_TOPIC'] ?? '-'},'
    //       '${config['SFTP_IP'] ?? '-'},'
    //       '${config['SFTP_USER_NAME'] ?? '-'},'
    //       '${config['SFTP_PASSWORD'] ?? '-'},'
    //       '${config['SFTP_PORT'] ?? '-'},'
    //       '${config['MQTTS_PORT'] ?? '-'},'
    //       '${config['MQTTS_STATUS'] ?? '-'},'
    //       '${config['REVERSE_SSH_BROKER_NAME'] ?? '-'},'
    //       '${config['REVERSE_SSH_PORT'] ?? '-'}';
    // }
  }

  void sendSelectedProject() {
    if (selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select a project")),
      );
      return;
    }

    final selectedConfig = configs[selectedIndex!];
    final formatted = formatConfig(selectedConfig);

    final payload = {
      "6100": [{"6101": formatted}],
    };

    print("Selected config index: $selectedIndex");
    print("Sending config for project: ${selectedConfig['PROJECT_NAME']}");
    print("Formatted: $formatted");
    print('jsonEncode(payload): ${jsonEncode(payload)}');

    // Uncomment this when ready to send
    MQTTManager().publish(jsonEncode(payload), 'AppToFirmware/${widget.deviceID}');

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sent to ${widget.deviceID}: $formatted")),
    );
  }

  void updateCode() {
    final payload = {
      "5700": [ {"5701": "28"}],
    };
    MQTTManager().publish(jsonEncode(payload), 'AppToFirmware/${widget.deviceID}');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configure MQTT: ${widget.deviceID}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<int>(
              value: selectedIndex,
              isExpanded: true,
              hint: const Text('Select Project'),
              items: List.generate(configs.length, (index) {
                final config = configs[index];
                return DropdownMenuItem<int>(
                  value: index,
                  child: Text('${config['PROJECT_NAME']} - ${config['SERVER_NAME']}'),
                );
              }),
              onChanged: (index) {
                setState(() {
                  selectedIndex = index;
                  formattedConfig = index != null
                      ? formatConfig(configs[index])
                      : null;
                });
              },
            ),
            const SizedBox(height: 20),
            // if (formattedConfig != null)
            //   Container(
            //     padding: const EdgeInsets.all(12.0),
            //     decoration: BoxDecoration(
            //       color: Colors.grey[100],
            //       border: Border.all(color: Colors.grey),
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: SingleChildScrollView(
            //       scrollDirection: Axis.horizontal,
            //       child: Text(
            //         formattedConfig!,
            //         style: const TextStyle(
            //           fontFamily: 'monospace',
            //           fontSize: 14,
            //         ),
            //       ),
            //     ),
            //   ),
            // const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: sendSelectedProject,
                  child: const Text('Send Settings'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                  ),
                  onPressed: updateCode,
                  child: const Text('Update HW Code'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
