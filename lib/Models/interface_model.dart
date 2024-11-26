class InterfaceModel
{
  int interfaceTypeId;
  String interface, interfaceDescription, active;

  InterfaceModel({
    this.interfaceTypeId = 0,
    this.interface ='',
    this.interfaceDescription = '',
    this.active = '',
  });

  factory InterfaceModel.fromJson(Map<String, dynamic> json) => InterfaceModel(
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