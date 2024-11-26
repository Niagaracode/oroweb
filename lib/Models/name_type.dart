class NameType
{
  NameType({
    this.nameTypeId = 0,
    this.nameType = 0,
    this.name = '',
    this.nameDescription = '',
    this.active = '',
  });

  int nameTypeId, nameType;
  String name, nameDescription, active;

  factory NameType.fromJson(Map<String, dynamic> json) => NameType(
    nameTypeId: json['nameTypeId'],
    nameType: json['nameType'],
    name: json['name'],
    nameDescription: json['nameDescription'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'nameTypeId': nameTypeId,
    'nameType': nameType,
    'name': name,
    'nameDescription': nameDescription,
    'active': active,
  };
}