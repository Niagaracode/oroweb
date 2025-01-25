final List<Map<String, dynamic>> bugReportSampleData = [
  {
    "errorId": 1,
    "userId": 78,
    "userName": "Nandhakumar",
    "mobileNumber": "9952626572",
    "groupId": 72,
    "groupName": "Nandhakumar",
    "controllerId": 704,
    "deviceName": "ORO GEM",
    "controllerDate": "2025-01-21",
    "controllerTime": "11:15:02",
    "errorCode": 11,
    "errorName": "HttpError",
    "status": "Pending",
    "description": null,
    "errorPayload": {
      "cC": "2CCF6760897C",
      "cM": [
        {
          "4201": {
            "Code": "11",
            "Name": "HttpError",
            "Message": "IT Team ?????",
            "HttpStatusCode": "Error",
            "HttpMessageCode": 0,
            "HttpMessage": "HttpIssue",
            "PayloadSource": "Source Not Received",
            "PayloadCode": "2600"
          }
        }
      ],
      "cD": "2025-01-21",
      "cT": "11:15:02",
      "mC": "4200"
    }
  },
  {
    "errorId": 2,
    "userId": 78,
    "userName": "Nandhakumar",
    "mobileNumber": "9952626572",
    "groupId": 72,
    "groupName": "Nandhakumar",
    "controllerId": 704,
    "deviceName": "ORO GEM",
    "controllerDate": "2025-01-21",
    "controllerTime": "11:15:02",
    "errorCode": 11,
    "errorName": "HttpError",
    "status": "Pending",
    "description": null,
    "errorPayload": {
      "cC": "2CCF6760897C",
      "cM": [
        {
          "4201": {
            "Code": "11",
            "Name": "HttpError",
            "Message": "IT Team ?????",
            "HttpStatusCode": "Error",
            "HttpMessageCode": 0,
            "HttpMessage": "HttpIssue",
            "PayloadSource": "Source Not Received",
            "PayloadCode": "2600"
          }
        }
      ],
      "cD": "2025-01-21",
      "cT": "11:15:02",
      "mC": "4200"
    }
  },
  {
    "errorId": 3,
    "userId": 78,
    "userName": "Nandhakumar",
    "mobileNumber": "9952626572",
    "groupId": 72,
    "groupName": "Nandhakumar",
    "controllerId": 704,
    "deviceName": "ORO GEM",
    "controllerDate": "2025-01-21",
    "controllerTime": "11:15:02",
    "errorCode": 11,
    "errorName": "HttpError",
    "status": "Pending",
    "description": null,
    "errorPayload": {
      "cC": "2CCF6760897C",
      "cM": [
        {
          "4201": {
            "Code": "11",
            "Name": "HttpError",
            "Message": "IT Team ?????",
            "HttpStatusCode": "Error",
            "HttpMessageCode": 0,
            "HttpMessage": "HttpIssue",
            "PayloadSource": "Source Not Received",
            "PayloadCode": "2600"
          }
        }
      ],
      "cD": "2025-01-21",
      "cT": "11:15:02",
      "mC": "4200"
    }
  },
];

class BugReportModel {
  int errorId;
  int userId;
  String userName;
  String mobileNumber;
  int groupId;
  String groupName;
  int controllerId;
  String deviceName;
  String controllerDate;
  String controllerTime;
  int errorCode;
  String errorName;
  String status;
  String description;
  Map<String, dynamic> errorPayload;
  String deviceId;

  BugReportModel({
    required this.errorId,
    required this.userId,
    required this.userName,
    required this.mobileNumber,
    required this.groupId,
    required this.groupName,
    required this.controllerId,
    required this.deviceName,
    required this.controllerDate,
    required this.controllerTime,
    required this.errorCode,
    required this.errorName,
    required this.status,
    required this.description,
    required this.errorPayload,
    required this.deviceId,
  });

  factory BugReportModel.fromJson(Map<String, dynamic> json) {
    return BugReportModel(
        errorId: json["errorId"],
        userId: json["userId"],
        userName: json["userName"],
        mobileNumber: json["mobileNumber"],
        groupId: json["groupId"],
        groupName: json["groupName"],
        controllerId: json["controllerId"],
        deviceName: json["deviceName"],
        controllerDate: json["controllerDate"],
        controllerTime: json["controllerTime"],
        errorCode: json["errorCode"],
        errorName: json["errorName"],
        status: json["status"],
        description: json["description"] ?? "Description",
        errorPayload: json["errorPayload"],
        deviceId: json["errorPayload"]['cC']
    );
  }
}