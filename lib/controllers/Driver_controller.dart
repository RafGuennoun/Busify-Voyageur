import 'package:busify_voyageur/Utils/constants.dart';
import 'package:busify_voyageur/models/Driver_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';



class DriverController {

  final String api = Constants().getAPI();

  Future<Driver> getDriver(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}driver/get", 
      data: json
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> res = (response.data) as Map<String, dynamic> ; 
      Driver driver = Driver.fromJson(res);
      return driver;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to get driver.');
    }
  }

  Future<bool> updateDriver(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}driver/update", 
      data: json
    );

    if (response.statusCode == 200) {
      debugPrint(response.data.toString());
      return true;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to update driver.');
    }
  }
}