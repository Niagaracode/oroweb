import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/MQTTManager.dart';
import '../../constants/MyFunction.dart';
import '../../constants/theme.dart';
import '../product_entry.dart';
import 'AdminDashboard.dart';
import '../my_preference.dart';
import '../product_inventory.dart';
import 'DealerDashboard.dart';

class BaseScreenController extends StatefulWidget {
  final String userName, countryCode, mobileNo;
  final bool fromLogin;
  final int userId, userType;
  final String? emailId;

  const BaseScreenController({
    Key? key,
    required this.userName,
    required this.countryCode,
    required this.mobileNo,
    required this.fromLogin,
    required this.userId,
    required this.userType,
    this.emailId,
  }) : super(key: key);

  @override
  State<BaseScreenController> createState() => _BaseScreenControllerState();
}

class _BaseScreenControllerState extends State<BaseScreenController> {
  int _selectedIndex = 0;
  late List<String> appBarTitles;

  @override
  void initState() {
    super.initState();
    appBarTitles = widget.userType == 1
        ? ['Home', 'Product', 'All Entry', 'My Preference']
        : ['Home', 'Product', 'My Preference'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: myTheme.primaryColor.withOpacity(0.01),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildNavigationRail(),
          Expanded(
            child: mainMenu(_selectedIndex),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationRail() {
    return NavigationRail(
      selectedIndex: _selectedIndex,
      backgroundColor: myTheme.primaryColorDark,
      labelType: NavigationRailLabelType.all,
      indicatorColor: myTheme.primaryColorLight,
      elevation: 5,
      leading: const Column(
        children: [
          Image(
            image: AssetImage("assets/images/oro_logo_white.png"),
            height: 40,
            width: 60,
          ),
          SizedBox(height: 20),
        ],
      ),
      trailing: _buildLogoutButton(),
      onDestinationSelected: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      destinations: _getNavigationDestinations(),
    );
  }

  List<NavigationRailDestination> _getNavigationDestinations() {
    final destinations = [
      const NavigationRailDestination(
        padding: EdgeInsets.only(top: 5),
        icon: Icon(Icons.dashboard_outlined),
        selectedIcon: Icon(Icons.dashboard_outlined, color: Colors.white),
        label: Text(''),
      ),
      const NavigationRailDestination(
        icon: Icon(Icons.inventory_2_outlined),
        selectedIcon: Icon(Icons.inventory_2_outlined, color: Colors.white),
        label: Text(''),
      ),
    ];

    if (widget.userType == 1) {
      destinations.add(
        const NavigationRailDestination(
          icon: Icon(Icons.topic_outlined),
          selectedIcon: Icon(Icons.topic_outlined, color: Colors.white),
          label: Text(''),
        ),
      );
    }

    destinations.add(
      const NavigationRailDestination(
        icon: Icon(Icons.manage_accounts_outlined),
        selectedIcon: Icon(Icons.manage_accounts_outlined, color: Colors.white),
        label: Text(''),
      ),
    );

    return destinations;
  }

  Widget _buildLogoutButton() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: IconButton(
            tooltip: 'Logout',
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            autofocus: true,
            focusColor: Colors.white,
            onPressed: _logout,
          ),
        ),
      ),
    );
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    MyFunction().clearMQTTPayload(context);
    MQTTManager().onDisconnected();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  Widget mainMenu(int index) {
    switch (index) {
      case 0:
        return widget.userType == 1?
        AdminDashboard(
          userName: widget.userName,
          countryCode: widget.countryCode,
          mobileNo: widget.mobileNo,
          userId: widget.userId,
        ) :
        DealerDashboard(
          userName: widget.userName,
          countryCode: widget.countryCode,
          mobileNo: widget.mobileNo,
          userId: widget.userId,
          emailId: widget.emailId ?? '',
          fromLogin: widget.fromLogin,
          userType: widget.userType,
        );
      case 1:
        return ProductInventory(
          userName: widget.userName,
          userId: widget.userId,
          userType: widget.userType,
        );
      case 2:
        return widget.userType == 1?
        const AllEntry() : MyPreference(userID: widget.userId);
      case 3:
        return MyPreference(userID: widget.userId);
      default:
        return const SizedBox();
    }
  }
}