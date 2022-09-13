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

  Future<bool> addTrack(Map<String, dynamic> infos, Map<String, dynamic> track) async {

    Map<String, dynamic> webId = {
      "webId" : infos["webId"]
    };

    LocationModel oldLocation = await getLocation(webId);
    LocationModel? newLocationModel;

    if (oldLocation.track.isEmpty) {
      print("is empty");
      String tracking = "[${track["latitude"]};${track["longitude"]}]";

      newLocationModel = LocationModel(oldLocation.lat, oldLocation.lon, tracking.toString());

    } else {
      print("is not empty");

      String old = oldLocation.track;

      List temp = old.split(',');

      if (temp.length<10) {
        String tracking = "$old,[${track["latitude"]};${track["longitude"]}]";
        newLocationModel = LocationModel(oldLocation.lat, oldLocation.lon, tracking.toString());
        
      } else {
        temp.removeAt(0);
        String newTemp = temp.toString();
        String oldTrack = newTemp.substring(1, newTemp.length -1);

        String tracking = "$oldTrack,[${track["latitude"]};${track["longitude"]}]";

        newLocationModel = LocationModel(oldLocation.lat, oldLocation.lon, tracking.toString());
        
      }
      
    }

    Map<String, dynamic> json = {
      "login" : infos["login"],
      "webId" : infos["webId"],
      "location" : {
        "lat" : newLocationModel.lat,
        "lon" : newLocationModel.lon,
        "track" : newLocationModel.track  
      }
    };

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