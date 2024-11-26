import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oro_irrigation_new/Screens/Config/NewPreference/preference_main_screen.dart';
import 'package:oro_irrigation_new/Screens/Customer/calibration.dart';
import 'package:oro_irrigation_new/Screens/map/listcustomervalve.dart';
import 'package:oro_irrigation_new/screens/Config/Constant/constant_tab_bar_view.dart';
import 'package:oro_irrigation_new/screens/Config/reset_Accumulation.dart';
 import 'DataAc/data_acquisition_main.dart';
import 'dealer_definition_config.dart';
import 'names_form.dart';


class ConfigScreen extends StatefulWidget {
  const ConfigScreen({Key? key, required this.userID, required this.customerID, required this.siteName, required  this.controllerId, required this.imeiNumber,}) : super(key: key);
  final int userID, customerID, controllerId;
  final String siteName, imeiNumber;

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> with SingleTickerProviderStateMixin
{
  static List<Object> configList = ['Names', 'Preferences','Constant', 'Dealer definition', 'Data acquisition','Reset Accumulation', 'Geography','Calibration'];
  final _configTabs = List.generate(configList.length, (index) => configList[index]);
  late final TabController _tabCont;
  int nvRSelection = 0;

  @override
  void initState() {
    _tabCont = TabController(length: configList.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
          selectedIndex: nvRSelection,
          onDestinationSelected: (int index) {
            // Handle item selection
            setState(() {
              nvRSelection = index;
            });

          },
          labelType: NavigationRailLabelType.all,
          destinations: const [
            NavigationRailDestination(
              icon: Icon(Icons.drive_file_rename_outline),
              label: Text('Names'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.settings_outlined),
              label: Text('Preferences'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.menu_open),
              label: Text('Constant'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.perm_identity_outlined),
              label: Text('Dealer definition'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.dataset_linked_outlined),
              label: Text('Data acquisition'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.reset_tv),
              label: Text('Reset Accumulation'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.location_on_outlined),
              label: Text('Geography'),
            ),
            NavigationRailDestination(
              icon: Icon(Icons.compass_calibration),
              label: Text('Calibration'),
            ),
          ],
        ),
        const VerticalDivider(thickness: 1, width: 1),
        Expanded(
          child: Center(
            child: nvRSelection == 0 ?
            Names(userID: widget.userID,  customerID: widget.customerID, controllerId: widget.controllerId,imeiNo: widget.imeiNumber,):
            nvRSelection == 1 ?
            PreferenceMainScreen(customerID: widget.customerID, controllerId: widget.controllerId, deviceId: widget.imeiNumber, userId: widget.customerID):
            // PreferencesScreen(customerID: widget.customerID, controllerID: widget.controllerId, userID: widget.userID, deviceId: widget.imeiNumber):
            nvRSelection == 2 ?
            ConstantInConfig(userId: widget.userID, customerId: widget.customerID, deviceId: widget.imeiNumber, controllerId: widget.controllerId,):
            nvRSelection == 3 ?
            DealerDefinitionInConfig(userId: widget.userID,  customerId: widget.customerID, controllerId: widget.controllerId, imeiNo: widget.imeiNumber,):
            nvRSelection == 4 ?
            DataAcquisitionMain(customerID: widget.customerID, controllerID: widget.controllerId, userId: widget.userID, deviceID: widget.imeiNumber,):
            nvRSelection == 5 ?
            Reset_Accumalation(controllerId: widget.controllerId, userId: widget.customerID, deviceID:  widget.imeiNumber) :
            nvRSelection == 6 ?
            CustomerDeviceListMap(controllerId: widget.controllerId, userId: widget.customerID, deviceID:  widget.imeiNumber) : Calibration(controllerId: widget.controllerId, userId: widget.customerID, deviceId:  widget.imeiNumber),

          ),
        ),
      ],
    );
  }
}

class ConfigPage extends StatelessWidget
{
  const ConfigPage({Key? key, required this.label, required this.userID, required this.customerID, required this.controllerId, required this.imeiNumber}) : super(key: key);
  final String label, imeiNumber;
  final int userID, customerID, controllerId;

  @override
  Widget build(BuildContext context)
  {
   if(label.toString()=='Names'){
      return Names(userID: userID,  customerID: customerID, controllerId: controllerId,imeiNo: imeiNumber,);
    }else if(label.toString()=='Dealer definition'){
      return DealerDefinitionInConfig(userId: userID,  customerId: customerID, controllerId: controllerId, imeiNo: imeiNumber);
    }else if(label.toString()=='Preferences'){
      return PreferenceMainScreen(userId: customerID, controllerId: controllerId, customerID: userID, deviceId: imeiNumber);
    }else if(label.toString()=='Data acquisition'){
      return DataAcquisitionMain(customerID: customerID, controllerID: controllerId, userId: userID, deviceID: imeiNumber);
    }else if(label.toString()=='Constant'){
      return ConstantInConfig(userId: userID, customerId: customerID, deviceId: imeiNumber, controllerId: controllerId,);
    }

    return Center(child: Text('Page of $label'));
  }
}