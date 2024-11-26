class SentAndReceivedModel
{
  SentAndReceivedModel({
    this.date = '',
    this.time = '',
    this.messageType = '',
    this.message = '',
    this.sentUser = '',
    this.sentMobileNumber = '',
    this.sentAndReceivedId = 0,
  });

  String date, time, messageType, message, sentUser, sentMobileNumber;
  int sentAndReceivedId;

  factory SentAndReceivedModel.fromJson(Map<String, dynamic> json) => SentAndReceivedModel(
    date: json['date'],
    time: json['time'],
    messageType: json['messageType'],
    message: json['message'],
    sentUser: json['sentUser'],
    sentMobileNumber: json['sentMobileNumber'],
    sentAndReceivedId: json['sentAndReceivedId'],
  );

  Map<String, dynamic> toJson() => {
    'date': date,
    'time': time,
    'messageType': messageType,
    'message': message,
    'sentUser': sentUser,
    'sentMobileNumber': sentMobileNumber,
    'sentAndReceivedId': sentAndReceivedId,
  };
}