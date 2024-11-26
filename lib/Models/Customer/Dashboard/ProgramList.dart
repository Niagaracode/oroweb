class ProgramList {
  final int programId;
  final int serialNumber;
  final String programName;
  final String defaultProgramName;
  final String programType;
  final String priority;
  final String startDate;
  final String startTime;
  final int sequenceCount;
  final String scheduleType;
  final String firstSequence;
  final String duration;
  final String programCategory;


  ProgramList({
    required this.programId,
    required this.serialNumber,
    required this.programName,
    required this.defaultProgramName,
    required this.programType,
    required this.priority,
    required this.startDate,
    required this.startTime,
    required this.sequenceCount,
    required this.scheduleType,
    required this.firstSequence,
    required this.duration,
    required this.programCategory,
  });

  factory ProgramList.fromJson(Map<String, dynamic> json) {
    //print('Program list :$json');
    return ProgramList(
      programId: json['programId'],
      serialNumber: json['serialNumber'],
      programName: json['programName'],
      defaultProgramName: json['defaultProgramName'],
      programType: json['programType'],
      priority: json['priority'],
      startDate: json['startDate'],
      startTime: json['startTime'],
      sequenceCount: json['sequenceCount'],
      scheduleType: json['scheduleType'],
      firstSequence: json['firstSequence'],
      duration: json['duration'],
      programCategory: json['programCategory'],
    );
  }
}