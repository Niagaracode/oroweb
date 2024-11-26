import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Models/notification_list_model.dart';
import '../../constants/http_service.dart';
import '../../constants/theme.dart';

class NotificationTypeList extends StatefulWidget {
  const NotificationTypeList({Key? key}) : super(key: key);

  @override
  State<NotificationTypeList> createState() => _NotificationTypeListState();
}

class _NotificationTypeListState extends State<NotificationTypeList> {

  final _formKey = GlobalKey<FormState>();
  TextEditingController notificationTypeCtl = TextEditingController();
  TextEditingController notificationDisCtl = TextEditingController();

  List<NotificationListModel> notificationList = <NotificationListModel>[];
  bool editNot = false;
  bool editActive = false;
  int sldNotTypeID = 0;


  @override
  void initState() {
    super.initState();
    getNotificationList();
  }

  Future<void> getNotificationList() async
  {
    final response = await HttpService().postRequest("getPushNotificationType", {});
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(response.body);
      notificationList = List.from(data["data"]).map((item) => NotificationListModel.fromJson(item)).toList();
      setState(() {});
    } else {
      _showSnackBar(response.body);
    }
  }


  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return Container(
      color:  Colors.blueGrey.shade50,
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: ListTile(
                      title: Text('Notification Types', style: myTheme.textTheme.titleLarge),
                      subtitle: Text('Notification types with Description', style: myTheme.textTheme.titleSmall),
                      trailing: IconButton(onPressed: ()
                      {
                        setState(() {
                          editNot = !editNot;
                          editActive = false;
                        });
                        notificationTypeCtl.clear();
                        notificationDisCtl.clear();
                      }, icon: editNot ? Icon(Icons.done_all, color: myTheme.primaryColor,) : Icon(Icons.edit_note_outlined, color: myTheme.primaryColor,)),
                    ),
                  ),
                  Expanded(
                      child: GridView.builder(
                        itemCount: notificationList.length,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsetsDirectional.all(5.0),
                            decoration: BoxDecoration(
                              color: notificationList[index].active=='1'? myTheme.primaryColor.withOpacity(0.2) : Colors.red.shade100,
                              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                            ),
                            child: ListTile(
                              title: Text(notificationList[index].notificationName,),
                              subtitle: Text(notificationList[index].notificationDescription,),
                              trailing: editNot ? Wrap(
                                spacing: 12, // space between two icons
                                children: <Widget>[
                                  IconButton(onPressed: ()
                                  {
                                    notificationTypeCtl.text = notificationList[index].notificationName;
                                    notificationDisCtl.text = notificationList[index].notificationDescription;
                                    sldNotTypeID = notificationList[index].pushNotificationId;

                                    setState(() {
                                      editActive = true;
                                    });

                                  }, icon: Icon(Icons.edit_outlined, color: myTheme.primaryColor,),),
                                  IconButton(onPressed: () async {
                                    final prefs = await SharedPreferences.getInstance();
                                    String userID = (prefs.getString('userId') ?? "");

                                    Map<String, Object> body = {
                                      'pushNotificationId': notificationList[index].pushNotificationId.toString(),
                                      'modifyUser': userID,
                                    };

                                    final Response response;
                                    if(notificationList[index].active=='1'){
                                      response = await HttpService().putRequest("inactivePushNotificationType", body);
                                    }else{
                                      response = await HttpService().putRequest("activePushNotificationType", body);
                                    }

                                    if(response.statusCode == 200)
                                    {
                                      var data = jsonDecode(response.body);
                                      if(data["code"]==200)
                                      {
                                        _showSnackBar(data["message"]);
                                        getNotificationList();
                                      }
                                      else{
                                        _showSnackBar(data["message"]);
                                      }
                                    }else{
                                      _showSnackBar(response.body);
                                    }

                                  }, icon: notificationList[index].active=='1'? Icon(Icons.check_circle_outlined, color: Colors.green,):Icon(Icons.unpublished_outlined, color: Colors.red,)),
                                ],
                              ): null,
                            ),
                          );
                        },
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: mediaQuery.size.width > 1200 ? 2 : 1,
                          childAspectRatio: mediaQuery.size.width / 250,
                        ),
                      )),
                ],
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              padding: const EdgeInsets.all(5),
              child: Column(
                children: [
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: ListTile(
                      title: Text("Add notification type", style: myTheme.textTheme.titleLarge),
                      subtitle: Text("Please fill out all details correctly.", style: myTheme.textTheme.titleSmall),
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: <Widget>[
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              const SizedBox(height: 10,),
                              TextFormField(
                                controller: notificationTypeCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Notification Type',
                                  icon: Icon(Icons.notifications_none),
                                ),
                              ),
                              const SizedBox(height: 13,),
                              TextFormField(
                                controller: notificationDisCtl,
                                validator: (value){
                                  if(value==null ||value.isEmpty){
                                    return 'Please fill out this field';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                                  border: OutlineInputBorder(),
                                  labelText: 'Notification Description',
                                  icon: Icon(Icons.content_paste_go),
                                ),
                              ),
                              const SizedBox(height: 20,),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                  Container(
                    height: 60,
                    color: Colors.white,
                    child: ListTile(
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ElevatedButton(
                            child: editActive ? const Text('Save'): const Text('Submit'),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();

                                final prefs = await SharedPreferences.getInstance();
                                String userID = (prefs.getString('userId') ?? "");
                                final Response response;

                                if(editActive){
                                  Map<String, Object> body = {
                                    "pushNotificationId": sldNotTypeID.toString(),
                                    'notificationName': notificationTypeCtl.text,
                                    'notificationDescription': notificationDisCtl.text,
                                    'modifyUser': userID,
                                  };
                                  response = await HttpService().putRequest("updatePushNotificationType", body);
                                }
                                else{
                                  Map<String, Object> body = {
                                    'notificationName': notificationTypeCtl.text,
                                    'notificationDescription': notificationDisCtl.text,
                                    'createUser': userID,
                                  };
                                  response = await HttpService().postRequest("createPushNotificationType", body);
                                }

                                if(response.statusCode == 200)
                                {
                                  var data = jsonDecode(response.body);
                                  if(data["code"]==200)
                                  {
                                    notificationTypeCtl.clear();
                                    notificationDisCtl.clear();
                                    _showSnackBar(data["message"]);
                                    getNotificationList();
                                  }
                                  else{
                                    _showSnackBar(data["message"]);
                                  }
                                }
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

}
