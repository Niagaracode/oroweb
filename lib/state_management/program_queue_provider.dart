import 'dart:convert';
import 'dart:developer';
import 'package:flutter/cupertino.dart';

import '../Models/Customer/program_queue_model.dart';
import '../constants/http_service.dart';


class ProgramQueueProvider extends ChangeNotifier{
  ProgramQueueModel? _programQueueResponse;
  ProgramQueueModel? get programQueueResponse => _programQueueResponse;

  HttpService httpService = HttpService();
  bool selectAll = false;
  void updateSelectAll() {
    selectAll = !selectAll;
    notifyListeners();
  }
  bool selectAll2 = false;
  void updateSelectAll2() {
    selectAll2 = !selectAll2;
    notifyListeners();
  }

  List<int> selectedIndexes1 = [];
  List<int> selectedIndexes2 = [];

  void toggleSelectIndex(int index) {
    if (selectedIndexes1.contains(index)) {
      selectedIndexes1.remove(index);
    } else {
      selectedIndexes1.add(index);
    }
    selectAll = false;
    notifyListeners();
  }

  void toggleSelectIndex2(int index) {
    if (selectedIndexes2.contains(index)) {
      selectedIndexes2.remove(index);
    } else {
      selectedIndexes2.add(index);
    }
    selectAll2 = false;
    notifyListeners();
  }

  void toggleSelectAll(int itemCount) {
    if (selectedIndexes1.length == itemCount) {
      selectedIndexes1.clear();
    } else {
      selectedIndexes1 = List.generate(itemCount, (index) => index);
    }
    notifyListeners();
  }

  void toggleSelectAll2(int itemCount) {
    if (selectedIndexes2.length == itemCount) {
      selectedIndexes2.clear();
    } else {
      selectedIndexes2 = List.generate(itemCount, (index) => index);
    }
    notifyListeners();
  }

  void updatePriority() {
    if(select) {
      if (selectedIndexes1.isNotEmpty) {
        List<ProgramQueue> removedItems = [];
        for (var index in selectedIndexes1) {
          ProgramQueue item = _programQueueResponse!.data.high[index];
          item.priority = "Low";
          _programQueueResponse!.data.low.add(item);
          removedItems.add(item);
        }
        _programQueueResponse!.data.high.removeWhere((item) => removedItems.contains(item));
        select = false;
        selectAll = false;
        selectedIndexes1.clear();
      }
    } else if(select2){
      if (selectedIndexes2.isNotEmpty) {
        List<ProgramQueue> removedItems = [];
        for (var index in selectedIndexes2) {
          ProgramQueue item = _programQueueResponse!.data.low[index];
          item.priority = "High";
          _programQueueResponse!.data.high.add(item);
          removedItems.add(item);
        }
        _programQueueResponse!.data.low.removeWhere((item) => removedItems.contains(item));
        select2 = false;
        selectAll2 = false;
        selectedIndexes2.clear();
      }
    }
    notifyListeners();
  }

  bool select = false;
  void updateSelection() {
    select = !select;
    notifyListeners();
  }
  bool select2 = false;
  void updateSelection2() {
    select2 = !select2;
    notifyListeners();
  }

  Future<void> getUserProgramQueueData(userId, controllerId) async {
    try {
      var userData = {
        "userId": userId,
        "controllerId": controllerId,
      };

      var getUserProgramQueue = await httpService.postRequest("getUserProgramQueue", userData);

      if (getUserProgramQueue.statusCode == 200) {
        final responseJson = getUserProgramQueue.body;
        final convertedJson = jsonDecode(responseJson);

        _programQueueResponse = ProgramQueueModel.fromJson(convertedJson);
      }
    } catch (e) {
      log('Error: $e');
    }
    notifyListeners();
  }

// void updateValues(newValue, index, type) {
//   switch()
//   _programQueueResponse!.data[index].startTime = newValue;
// }
}