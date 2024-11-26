class InterfaceType
{
  InterfaceType({
    this.interfaceTypeId = 0,
    this.interface = '',
    this.interfaceDescription = '',
    this.active = '',
  });

  int interfaceTypeId;
  String interface, interfaceDescription, active;

  factory InterfaceType.fromJson(Map<String, dynamic> json) => InterfaceType(
    interfaceTypeId: json['interfaceTypeId'],
    interface: json['interface'],
    interfaceDescription: json['interfaceDescription'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'interfaceTypeId': interfaceTypeId,
    'interface': interface,
    'interfaceDescription': interfaceDescription,
    'active': active,
  };
}