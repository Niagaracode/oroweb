class WidgetType
{
  int widgetTypeId;
  String widget, widgetDescription, active;

  WidgetType({
    this.widgetTypeId = 0,
    this.widget = '',
    this.widgetDescription = '',
    this.active = '',
  });

  factory WidgetType.fromJson(Map<String, dynamic> json) => WidgetType(
    widgetTypeId: json['widgetTypeId'],
    widget: json['widget'],
    widgetDescription: json['widgetDescription'],
    active: json['active'],
  );

}