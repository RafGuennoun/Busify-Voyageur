import 'package:busify_voyageur/Utils/constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../models/Location_model.dart';


class LocationController {

  final String api = Constants().getAPI();
  
  Future<LocationModel> getLocation(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}location/get", 
      data: json
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> res = (response.data) as Map<String, dynamic> ; 
      LocationModel location = LocationModel.fromJson(res);
      return location;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to get location.');
    }
  }

  Future<bool> setLocation(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}location/set", 
      data: json
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to set location.');
    }
  }
}