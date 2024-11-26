import 'package:flutter/cupertino.dart';

class AppImages {
  static const String pngPath = "assets/images/";
  static const String gifPath = "assets/GifFile/";

  static const String irrigationPumpOFF = "dp_irr_pump.png";
  static const String irrigationPumpON = "dp_irr_pump_g.gif";
  static const String irrigationPumpNotON = "dp_irr_pump_y.png";
  static const String irrigationPumpNotOFF = "dp_irr_pump_r.png";

  static const String filterOFF = "dp_filter.png";
  static const String filterON = "dp_filter_g.png";
  static const String filterNotON = "dp_filter_y.png";
  static const String filterNotOFF = "dp_filter_r.png";

  static const String boosterPumpOFF = "dp_fert_booster_pump.png";
  static const String boosterPumpON = "dp_fert_booster_pump_g.gif";
  static const String boosterPumpNotON = "dp_fert_booster_pump_y.png";
  static const String boosterPumpNotOFF = "dp_fert_booster_pump_r.png";

  static const String soilMoistureSensor = "moisture_sensor.png";
  static const String pressureSensor = "pressure_sensor.png";
  static const String levelSensor = "level_sensor.png";

  static const String agitatorOFF = "dp_agitator_right.png";
  static const String agitatorON = "dp_agitator_right_g.gif";
  static const String agitatorNotON = "dp_agitator_right_y.png";
  static const String agitatorNotOFF = "dp_agitator_right_r.png";


  static Widget getAsset(String imageKey, int status, String type) {
    String imagePathFinal;
    switch (imageKey) {
      case 'sourcePump' || 'irrigationPump':
        imagePathFinal = _getIrrigationPumpImagePath(status);
        break;
      case 'filter':
        imagePathFinal = _getFilterImagePath(status);
        break;
      case 'booster':
        imagePathFinal = _getBoosterImagePath(status);
        break;
      case 'sensor':
        imagePathFinal = _getSensorImagePath(type);
        break;
      case 'agitator':
        imagePathFinal = _getAgitatorImagePath(status);
        break;
      default:
        imagePathFinal = '';
    }

    if(imagePathFinal.contains('.gif')){
      return Image.asset('$gifPath$imagePathFinal');
    }
    return Image.asset('$pngPath$imagePathFinal');
  }

  static String _getIrrigationPumpImagePath(int status) {
    switch (status) {
      case 0:
        return irrigationPumpOFF;
      case 1:
        return irrigationPumpON;
      case 2:
        return irrigationPumpNotON;
      case 3:
        return irrigationPumpNotOFF;
      default:
        return '';
    }
  }

  static String _getFilterImagePath(int status) {
    switch (status) {
      case 0:
        return filterOFF;
      case 1:
        return filterON;
      case 2:
        return filterNotON;
      case 3:
        return filterNotOFF;
      default:
        return '';
    }
  }

  static String _getBoosterImagePath(int status) {
    switch (status) {
      case 0:
        return boosterPumpOFF;
      case 1:
        return boosterPumpON;
      case 2:
        return boosterPumpNotON;
      case 3:
        return boosterPumpNotOFF;
      default:
        return '';
    }
  }

  static String _getSensorImagePath(String type) {
    if(type.contains('SM')){
      return soilMoistureSensor;
    }if(type.contains('LV')){
      return levelSensor;
    }else{
      return pressureSensor;
    }
  }

  static String _getAgitatorImagePath(int status) {
    switch (status) {
      case 0:
        return agitatorOFF;
      case 1:
        return agitatorON;
      case 2:
        return agitatorNotON;
      case 3:
        return agitatorNotOFF;
      default:
        return '';
    }
  }
}