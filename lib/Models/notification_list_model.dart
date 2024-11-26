class NotificationListModel {
  final int pushNotificationId;
  final String notificationName;
  final String notificationDescription;
  bool selected;
  final String active;

  NotificationListModel({
    required this.pushNotificationId,
    required this.notificationName,
    required this.notificationDescription,
    required this.selected,
    required this.active,
  });

  factory NotificationListModel.fromJson(Map<String, dynamic> json) {

    bool hasSelectedKey = json.containsKey('selected');
    bool hasActiveKey = json.containsKey('active');

    return NotificationListModel(
      pushNotificationId: json['pushNotificationId'],
      notificationName: json['notificationName'],
      notificationDescription: json['notificationDescription'] ?? '',
      selected: hasSelectedKey? json['selected']:false,
      active: hasActiveKey? json['active']:'0',
    );
  }
}