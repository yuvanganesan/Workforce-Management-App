import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/ratings.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/httpException.dart';
import 'package:intl/intl.dart';

class RatingsProvider with ChangeNotifier {
  List<Ratings> _empRatingCardList = [
    // Ratings(empId: '2', name: "Yuvan", stageId: '0', id: '0', ratingStar: 4),
    // Ratings(empId: '3', name: 'Salvin', stageId: '0', id: '0', ratingStar: 4.5),
    // Ratings(empId: '4', name: "Karthick", stageId: '0', id: '0', ratingStar: 0),
    // Ratings(empId: '2', name: "Yuvan", stageId: '0', id: '0', ratingStar: 4),
    // Ratings(empId: '3', name: 'Salvin', stageId: '0', id: '0', ratingStar: 4.5),
    // Ratings(empId: '4', name: "Karthick", stageId: '0', id: '0', ratingStar: 0),
    // Ratings(empId: '2', name: "Yuvan", stageId: '0', id: '0', ratingStar: 4),
    // Ratings(empId: '3', name: 'Salvin', stageId: '0', id: '0', ratingStar: 4.5),
    // Ratings(empId: '4', name: "Karthick", stageId: '0', id: '0', ratingStar: 0)
  ];

  Map<String, String> _dropDownItems = {};

  List<Ratings> get empRatingCardList {
    return [..._empRatingCardList];
  }

  Map<String, String> get dropDownButtonItems {
    return {..._dropDownItems};
  }

  final _ip = 'http://192.168.1.101:94';
  Future<void> fetchDropDownItem() async {
    try {
      final url = Uri.parse('$_ip/Overtime/GetWorkstation');
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> loadedData =
            (json.decode(response.body) as Map<String, dynamic>)['data'];

        if (loadedData == null) {
          throw HttpException('There is no Employee');
        }
        Map<String, String> dropDownFetch = {};
        loadedData.forEach((item) {
          dropDownFetch.update(
            item['STAGE_ID'].toString(),
            (value) => '',
            ifAbsent: () => item['DESCRIPTION'],
          );
        });
        _dropDownItems = dropDownFetch;
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchRatingCardList(DateTime date) async {
    try {
      final url = Uri.parse(
          '$_ip/Overtime/GetPerformancebyDate?SWIPE_DATE=${DateFormat('yyyy-MM-dd').format(date)}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> loadedData =
            (json.decode(response.body) as Map<String, dynamic>)['data'];

        if (loadedData == null) {
          throw HttpException('There is no records');
        }

        List<Ratings> empRatingCardFetch = [];
        loadedData.forEach((emp) {
          empRatingCardFetch.add(Ratings(
              id: emp['ID'].toString(),
              name: emp['NAME'],
              ratingStar: emp['RATING'],
              stageId: emp['STAGE_ID'].toString(),
              empId: emp['EMP_ID'].toString(),
              date: emp['WORKED_DATE']));
        });

        _empRatingCardList = empRatingCardFetch;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  void updateRatingStar(double value, int index) {
    _empRatingCardList[index].ratingStar = value;
    _empRatingCardList[index].isModified = true;
  }

  void updateStageId(String stageName, int index) {
    _empRatingCardList[index].stageId = _dropDownItems.keys
        .firstWhere((key) => _dropDownItems[key] == stageName);
    _empRatingCardList[index].isModified = true;
  }

  Future<void> saveRatings() async {
    try {
      //  print('saved');
      final url = Uri.parse('$_ip/Overtime/InsertUpdatePerformance');

      List<Map> data = List.generate(_empRatingCardList.length, (index) {
        if (_empRatingCardList[index].isModified == true) {
          _empRatingCardList[index].isModified = false;
          return {
            "EMP_ID": int.parse(_empRatingCardList[index].empId),
            "ID": int.parse(_empRatingCardList[index].id),
            "NAME": _empRatingCardList[index].name,
            "STAGE_ID": int.parse(_empRatingCardList[index].stageId),
            "RATING": _empRatingCardList[index].ratingStar,
            "WORKED_DATE": _empRatingCardList[index].date
          };
        }
        return {};
      });

      final response = await http.post(
        url,
        body: json.encode(data),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        },
      );
      //  print(response.statusCode);
    } catch (error) {
      throw error;
    }

    //notifyListeners();
  }
}
