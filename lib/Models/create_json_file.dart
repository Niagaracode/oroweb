import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CreateJsonFile{

  Future<void> writeDataInJsonFile(String fileName,Map<String,dynamic> jsonData)async{
    try{
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${fileName}.json');
      final encodedData = jsonEncode(jsonData);
      await file.writeAsString(encodedData);
      print('JSON data written to ${file.path}');
    } catch (e, stackTrace) {
      print('Error: $e');
      print('stackTrace: $stackTrace');
    }
  }

  Future<Map<String,dynamic>> readDataFromJsonFile(String fileName)async{
    try{
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/${fileName}.json');
      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final jsonData = json.decode(jsonString);
        print('JSON data read from ${file.path}');
        return jsonData;
      } else {
        print('JSON file does not exist');
        return {'data' : 'nothing'};
      }
    }catch(e){
      print('Error is : ${e.toString()}');
      return {
        'error' : e.toString()
      };
    }
  }

}