class ContactList
{
  ContactList({
    this.contactTypeId = 0,
    this.contact = '',
    this.contactDescription = '',
    this.active = '',
  });

  int contactTypeId;
  String contact, contactDescription, active;

  factory ContactList.fromJson(Map<String, dynamic> json) => ContactList(
    contactTypeId: json['contactTypeId'],
    contact: json['contact'],
    contactDescription: json['contactDescription'],
    active: json['active'],
  );

  Map<String, dynamic> toJson() {
    return {
      'contactTypeId': contactTypeId,
      'contact': contact,
      'contactDescription': contactDescription,
      'active': active,
    };
  }

}