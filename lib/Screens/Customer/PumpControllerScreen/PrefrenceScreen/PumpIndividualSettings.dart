import 'package:flutter/material.dart';

import '../../../../Models/Customer/Dashboard/PumpControllerModel/PumpSettingsMDL.dart';
import '../../../../constants/snack_bar.dart';
import '../../../../constants/theme.dart';

class PumpIndividualSettings extends StatefulWidget {
  const PumpIndividualSettings({Key? key, required this.pumpControllerSettings, required this.pumpInx}) : super(key: key);
  final PumpSettingsMDL pumpControllerSettings;
  final int pumpInx;

  @override
  State<PumpIndividualSettings> createState() => _PumpIndividualSettingsState();
}

class _PumpIndividualSettingsState extends State<PumpIndividualSettings> {

  Map<int, bool> switchValues = {};
  Map<int, TimeOfDay> timeValues = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.teal.shade50,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
                itemCount: widget.pumpControllerSettings.individualPumpSetting?[0].settingList?.length ?? 0,
                itemBuilder: (context, index) {
                  var settingGroup = widget.pumpControllerSettings.individualPumpSetting?[widget.pumpInx].settingList?[index];
                  String groupName = settingGroup?.name ?? 'Unknown Group';
                  List<SettingCmm> settings = settingGroup?.setting ?? [];

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        color: Colors.teal.shade50,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(groupName.toUpperCase(),
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                        ),
                      ),
                      GridView.builder(
                        //physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 8.5,
                          mainAxisSpacing: 0.0,
                          crossAxisSpacing: 0.0,
                        ),
                        itemCount: settings.length,
                        itemBuilder: (context, settingIndex) {
                          var setting = settings[settingIndex];
                          int widgetTypeId = setting.widgetTypeId ?? 0;
                          String title = setting.title ?? 'Unknown Title';
                          String iconCodePoint = setting.iconCodePoint ?? '0xe000';
                          String iconFontFamily = setting.iconFontFamily ?? 'MaterialIcons';
                          var value = setting.value;

                          int settingKey = index * 1000 + settingIndex;
                          if (value.runtimeType == bool && !switchValues.containsKey(settingKey)) {
                            switchValues[settingKey] = value;
                          }

                          // Initialize time value if not already in the map
                          if (widgetTypeId == 3 && !timeValues.containsKey(settingKey)) {
                            timeValues[settingKey] = TimeOfDay(
                              hour: int.parse(value.split(':')[0]),
                              minute: int.parse(value.split(':')[1]),
                            );
                          }

                          return ListTile(
                            leading: Icon(
                              IconData(int.parse(iconCodePoint), fontFamily: iconFontFamily),
                            ),
                            title: Text(title),
                            trailing: SizedBox(
                              width: widgetTypeId == 1 ? 70 : widgetTypeId == 2 ? 50 : 100,
                              child: _buildWidget(widgetTypeId, value, settingKey),
                            ),
                          );
                        },
                      ),
                    ],
                  );

                }),
          ),
          SizedBox(
            height: 50,
            width: MediaQuery.sizeOf(context).width,
            child: ListTile(trailing: MaterialButton(
              color: Colors.green,
              textColor: Colors.white,
              onPressed:() async {
                GlobalSnackBar.show(context, 'Settings restore successfully', 200);
              },
              child: const Text('Restore'),
            ),),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget(int widgetTypeId, dynamic value, int settingKey) {
    switch (widgetTypeId) {
      case 1:
        return SizedBox(
          width: 70,
          child: TextField(
            textAlign: TextAlign.center,
            controller: TextEditingController(text: value?.toString() ?? ''),
          ),
        );
      case 2:
        return SizedBox(
          width: 50,
          child: value.runtimeType==bool? Transform.scale(
            scale: 0.7,
            child: Switch(
              activeColor: Colors.white,
              activeTrackColor: myTheme.primaryColorDark,
              value: switchValues[settingKey] ?? false,
              onChanged: (value) {
                setState(() {
                  switchValues[settingKey] = value;
                });
              },
            ),
          ):
          Text('data'),
        );
      case 3:
        return SizedBox(
          width: 80,
          child: SizedBox(
            width: 100, // Adjust width as needed
            child: TextButton(
              onPressed: () async {
                TimeOfDay? pickedTime = await showTimePicker(
                  context: context,
                  initialTime: timeValues[settingKey] ?? TimeOfDay.now(),
                );
                if (pickedTime != null) {
                  setState(() {
                    timeValues[settingKey] = pickedTime;
                  });
                }
              },
              child: Text(timeValues[settingKey]?.format(context) ?? 'Select Time'),
            ),
          ),
        );
      default:
        return Container(); // Use a constrained widget or size constraints
    }
  }
}
