

class DataConvert{

  //TODO: string time into integer seconds
  int parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int totalSeconds = ((int.parse(parts[0]) * 3600) + (int.parse(parts[1]) * 60) + (int.parse(parts[2])));
    return totalSeconds;
  }

  //TODO: integer seconds into string time
  String formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;
    String hoursStr = hours.toString().padLeft(2, '0');
    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = remainingSeconds.toString().padLeft(2, '0');
    return '$hoursStr:$minutesStr:$secondsStr';
  }

  //TODO: string hrs into string time:min:sec
  String convertHoursToTime(double hours) {
    int wholeHours = hours.floor();
    double fractionalPart = hours - wholeHours;
    int minutes = (fractionalPart * 60).floor();
    double fractionalMinutes = (fractionalPart * 60) - minutes;
    int seconds = (fractionalMinutes * 60).floor();
    return '$wholeHours:$minutes:$seconds';
  }

  //TODO: string time(00:00:00) into string liters
  double convertTimeToLiters(String time, int rate) {
    List<String> parts = time.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);
    double totalTimeInHours = hours + (minutes / 60) + (seconds / 3600);
    double totalLiters = totalTimeInHours * rate;

    return totalLiters;
  }

}