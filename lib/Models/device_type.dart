class DeviceType
{
  DeviceType({
    this.deviceTypeId = 0,
    this.device = '',
    this.deviceDescription = '',
    this.active = '',
  });

  int deviceTypeId;
  String device, deviceDescription, active;

  factory DeviceType.fromJson(Map<String, dynamic> json) => DeviceType(
    deviceTypeId: json['deviceTypeId'],
    device: json['device'],
    deviceDescription: json['deviceDescription'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'deviceTypeId': deviceTypeId,
    'device': device,
    'deviceDescription': deviceDescription,
    'active': active,
  };
}