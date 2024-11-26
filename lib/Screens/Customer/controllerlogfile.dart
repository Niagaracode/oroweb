import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../../../../constants/MQTTManager.dart';
import '../../../../constants/theme.dart';
import '../../../../state_management/MqttPayloadProvider.dart';
import '../../../../state_management/overall_use.dart';
import '../../constants/snack_bar.dart';
import '../../screens/Customer/IrrigationProgram/program_library.dart';

class ControllerLog extends StatefulWidget {
  final String deviceID;

  const ControllerLog({Key? key, required this.deviceID}) : super(key: key);

  @override
  _ControllerLogState createState() => _ControllerLogState();
}

class _ControllerLogState extends State<ControllerLog> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late OverAllUse overAllPvd;
  late MqttPayloadProvider mqttPayloadProvider;
  MQTTManager manager = MQTTManager();
  int valueForTab = 7;
  String logString = '';
  // bool checksucess = false;


  @override
  void initState() {
    super.initState();
    mqttPayloadProvider = Provider.of<MqttPayloadProvider>(context, listen: false);
    overAllPvd = Provider.of<OverAllUse>(context, listen: false);
    _tabController = TabController(length: 5, vsync: this);
    manager.unsubscribeFromTopic('FirmwareToApp/${widget.deviceID}');
    manager.subscribeToTopic('OroGemLog/${widget.deviceID}');
    // mqttConfigureAndConnect();
  }

  Future<String> getLogFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/log.txt';
  }

  Future<void> writeLog(String message) async {
    final path = await getLogFilePath();
    final file = File(path);
    await file.writeAsString('$message\n', mode: FileMode.append);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3),
    ));
  }

  @override
  Widget build(BuildContext context) {
    mqttPayloadProvider = Provider.of<MqttPayloadProvider>(context, listen: true);
    status();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: myTheme.primaryColor,
        title: Text('Controller Log'),
      ),
      body: Column(
        children: [
          // SizedBox(height: 20,child: Text(logString),),
          // SizedBox(height: 5),
          TabBar(
            controller: _tabController,
            onTap: (value) {
              setState(() {
                valueForTab = value + 7;
              });
            },
            tabs: const [
              Tab(text: 'Schedule'),
              Tab(text: 'UART'),
              Tab(text: 'UART-0'),
              Tab(text: 'UART-4'),
              Tab(text: 'Mqtt'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildScrollableText(mqttPayloadProvider.sheduleLog),
                _buildScrollableText(mqttPayloadProvider.uardLog),
                _buildScrollableText(mqttPayloadProvider.uard0Log),
                _buildScrollableText(mqttPayloadProvider.uard4Log),
                _buildScrollableText(""),
              ],
            ),
          ),
          SizedBox(height: 5),
          Center(
            child:  Wrap(
              alignment: WrapAlignment.center,
              spacing: 10.0,
              children: [
                valueForTab != 11 ? FilledButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.green)),
                  onPressed: () {
                    _showSnackBar("Start sending to Controller log...");
                    getlog(valueForTab);
                  },
                  child: Text('Start'),
                ) : SizedBox(),
                SizedBox(width: 10),
                valueForTab != 11 ? FilledButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
                  onPressed: () {
                    _showSnackBar("Stop sending to Controller log...");
                    getlog(11);
                  },
                  child: Text('Stop'),
                ) : SizedBox(),
                valueForTab != 11 ? SizedBox(width: 10) : SizedBox(),
                valueForTab != 11 ? FilledButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey)),
                  onPressed: () {
                    _showSnackBar("Clear Controller log...");
                    if (valueForTab == 7) {
                      setState(() {
                        mqttPayloadProvider.sheduleLog = '';
                      });
                    } else if (valueForTab == 8) {
                      setState(() {
                        mqttPayloadProvider.uardLog = '';
                      });
                    } else if (valueForTab == 9) {
                      setState(() {
                        mqttPayloadProvider.uard0Log = '';
                      });
                    } else if (valueForTab == 10) {
                      setState(() {
                        mqttPayloadProvider.uard4Log = '';
                      });
                    }
                  },
                  child: Text('Clear'),
                ) : SizedBox(),
                valueForTab != 11 ? SizedBox(width: 10) : SizedBox(),
                valueForTab != 11 ? TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue),foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    _showSnackBar("Today log send FTP...");
                    getlog(valueForTab + 5);
                  },
                  child: Text('Today log send FTP'),
                ) : SizedBox(),
                valueForTab != 11 ? SizedBox(width: 10) : SizedBox(),
                valueForTab != 11 ?  TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.blue),foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    _showSnackBar("Yesterday log send FTP...");
                    getlog(valueForTab + 10);
                  },
                  child: Text('Yesterday log send FTP'),
                ) : SizedBox(),
                valueForTab != 11 ?  SizedBox(width: 10) : SizedBox(),
                valueForTab == 11 ? TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.cyan),foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    _showSnackBar("Today Mqtt log send FTP...");
                    getlog(16);
                  },
                  child: Text('Today Mqtt log FTP'),
                ) : SizedBox(),
                SizedBox(width: 10),
                valueForTab == 11 ?  TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.cyan),foregroundColor: MaterialStateProperty.all(Colors.white)),
                  onPressed: () {
                    _showSnackBar("Yesterday Mqtt log  FTP...");
                    getlog(21);
                  },
                  child: Text('Yesterday log send FTP'),
                ) : SizedBox(),

              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollableText(String text) {

    final ScrollController scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child:  ScrollableTextWithSearch(text: text.isNotEmpty ? text : "Waiting...",)   //SelectableText(),
    );
  }



  Future<void> ftpstatus(BuildContext context) async{
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Consumer<MqttPayloadProvider>(
              builder: (context, mqttPayloadProvider, child) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    logString.contains("LogFileDetailsUpdated - Success") ? Icon(Icons.check_circle, color: Colors.green, size: 50) : CircularProgressIndicator(),
                    SizedBox(height: 16),
                    logString.contains("LogFileDetailsUpdated - Success") ? Text("Success...") : Text("Please wait..."),
                    SizedBox(height: 16),
                    Text(logString), //
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: logString.contains("LogFileDetailsUpdated - Success") ? Text("Ok") : Text("Cancel"),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );

    bool dialogOpen = true;

    while (dialogOpen) {
      await Future.delayed(Duration(seconds: 1));
      if (logString.contains("Success") || logString.contains("Won")) {
        // setState(() {
        //   checksucess = true;
        // });
        //   dialogOpen = false;
        //   Navigator.of(context).pop();
      }
    }

  }

  // Future<void> ftpstatus(BuildContext context) async {
  //   bool isSuccess = false;
  //    print("isSuccess---->$isSuccess");
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {
  //       return StatefulBuilder(
  //         builder: (context, setState) {
  //           return Dialog(
  //             child: Padding(
  //               padding: EdgeInsets.all(16.0),
  //               child: Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: [
  //                   // Show success icon or progress indicator based on status
  //                   isSuccess
  //                       ? Icon(Icons.check_circle, color: Colors.green, size: 50)
  //                       : CircularProgressIndicator(),
  //                   SizedBox(height: 16),
  //
  //                   // Show success text or waiting text based on status
  //                   Text(isSuccess ? "Success" : "Please wait..."),
  //
  //                   SizedBox(height: 16),
  //                   Text(logString), // Display the log string
  //
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.of(context).pop(); // Dismiss dialog
  //                     },
  //                     // Change button text based on status
  //                     child: Text(isSuccess ? "OK" : "Cancel"),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  //
  //   bool dialogOpen = true;
  //
  //   while (dialogOpen) {
  //     await Future.delayed(Duration(seconds: 1));
  //
  //     // Check for success condition
  //     if (logString.contains("Success") || logString.contains("Won")) {
  //       setState(() {
  //         print("Success inside");
  //         isSuccess = true; // Update the state to show success
  //       });
  //       // await Future.delayed(Duration(seconds: 2)); // Optionally wait a bit
  //       // dialogOpen = false;
  //       // Navigator.of(context).pop(); // Close dialog after success
  //     }
  //   }
  // }


  status() {
    Map<String, dynamic>? ctrldata = mqttPayloadProvider.messageFromHw;
    print("status ctrldata---->$ctrldata");
    if ((ctrldata != null && ctrldata.isNotEmpty)) {
      var name = ctrldata['Name'];
      logString = ctrldata['Name'];

    }


  }

  Future<void> getlog(int data) async {
    await manager.unsubscribeFromTopic('OroGemLog/${widget.deviceID}');
    await manager.subscribeToTopic('FirmwareToApp/${widget.deviceID}');
    await Future.delayed(Duration(seconds: 1), () async{
      if (data == 7 || data == 8 || data == 9 || data == 10 || data == 11)
      {
        String payloadCode = "4202";
        if (data == 7 || data == 8 || data == 9 || data == 10 || data == 11) {
          payloadCode = "5700";
        }

        Map<String, dynamic> payLoadFinal = {
          "5700": [
            {"5701": "$data"},
          ]
        };
        if (MQTTManager().isConnected == true) {
          await validatePayloadSent(
              dialogContext: context,
              context: context,
              mqttPayloadProvider: mqttPayloadProvider,
              acknowledgedFunction: () {
                manager.subscribeToTopic('OroGemLog/${widget.deviceID}');
              },
              payload: payLoadFinal,
              payloadCode: payloadCode,
              deviceId: widget.deviceID,
              maxWaitTime: 10
          );
        } else {
          GlobalSnackBar.show(context, 'MQTT is Disconnected', 201);
        }
      }
      else
      {

        print("getlog call");
        String payLoadFinal1 = jsonEncode({
          "5700": [
            {"5701": "$data"},
          ]
        });

        MQTTManager().publish(payLoadFinal1, 'AppToFirmware/${widget.deviceID}');
        await ftpstatus(context);
      }
    });


  }

  @override
  void dispose() {
    getlog(11);
    _tabController.dispose();
    // _scrollController.dispose();
    manager.unsubscribeFromTopic('OroGemLog/${widget.deviceID}');
    super.dispose();
  }
}


class ScrollableTextWithSearch extends StatefulWidget {
  final String text;

  ScrollableTextWithSearch({
    required this.text,
  });

  @override
  _ScrollableTextWithSearchState createState() =>
      _ScrollableTextWithSearchState();
}

class _ScrollableTextWithSearchState extends State<ScrollableTextWithSearch> {
  String _searchQuery = '';  // Query text to match
  ScrollController _scrollController = ScrollController();
  List<int> _matches = [];   // List of match positions
  TextEditingController _searchController = TextEditingController();
  int _matchCount = 0;

  @override
  void initState() {
    super.initState();
    // Add listener to the searchController to update the search query when text changes
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    // Always dispose controllers when done
    _scrollController.dispose();
    _searchController.removeListener(_onSearchChanged);
    super.dispose();
  }

  // Handle search query change from the controller
  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _matches = _findMatches(widget.text, _searchQuery);
    });
  }

  // Highlights the matched text and returns a list of TextSpan
  List<TextSpan> _highlightText(String text, List<int> matchPositions) {
    List<TextSpan> children = [];
    int start = 0;

    for (int i = 0; i < matchPositions.length; i++) {
      if (start < matchPositions[i]) {
        children.add(TextSpan(text: text.substring(start, matchPositions[i])));
      }
      children.add(TextSpan(
        text: text.substring(matchPositions[i], matchPositions[i] + _searchQuery.length),
        style: TextStyle(backgroundColor: Colors.yellow), // Highlight color
      ));
      start = matchPositions[i] + _searchQuery.length;
    }

    if (start < text.length) {
      children.add(TextSpan(text: text.substring(start)));
    }

    return children;
  }

  // Finds matches and returns a list of start positions of the matches
  List<int> _findMatches(String text, String query) {
    List<int> matches = [];
    int start = 0;

    String lowerText = text.toLowerCase();
    String lowerQuery = query.toLowerCase();

    while (start < lowerText.length) {
      start = lowerText.indexOf(lowerQuery, start);
      if (start == -1) break;
      matches.add(start);
      start += lowerQuery.length;
    }

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    // Get the list of match positions
    final List<int> matches = _searchQuery.isEmpty
        ? []
        : _findMatches(widget.text, _searchQuery);
    _matchCount = matches.length;

    // Scroll to the first match if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,  // Use passed controller
            decoration: InputDecoration(
              labelText: 'Search',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _searchQuery = _searchController.text;
                    _matches = _findMatches(widget.text, _searchQuery);
                  });
                },
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('Matches found: $_matchCount', style: TextStyle(fontSize: 16)),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SelectableText.rich(
                TextSpan(
                  children: _highlightText(widget.text, matches),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

