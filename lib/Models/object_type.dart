class ObjectType
{
  ObjectType({
    this.objectTypeId = 0,
    this.object = '',
    this.objectDescription = '',
    this.active = '',
  });

  int objectTypeId;
  String object, objectDescription, active;

  factory ObjectType.fromJson(Map<String, dynamic> json) => ObjectType(
    objectTypeId: json['objectTypeId'],
    object: json['object'],
    objectDescription: json['objectDescription'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() => {
    'objectTypeId': objectTypeId,
    'object': object,
    'objectDescription': objectDescription,
    'active': active,
  };
}