import 'package:busify_voyageur/Utils/constants.dart';
import 'package:busify_voyageur/models/Bus_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';



class BusController{

  final String api = Constants().getAPI();

  Future<List> buses() async {
    Response response;
    var dio = Dio();
    response = await dio.get("${api}bus/buses");
    if (response.statusCode == 200) {
      List<dynamic> buses = response.data;
      return buses;
    } else {
      throw Exception('Failed to get buses');
    }
  }

  Future<Bus> getBus(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}bus/get", 
      data: json
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> res = (response.data) as Map<String, dynamic> ; 
      Bus bus = Bus.fromJson(res);
      return bus;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to get bus data.');
    }
  }

  Future<bool> addBus(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}bus/add", 
      data: json
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to add bus');
    }
  }

  Future<bool> updateBus(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}bus/update", 
      data: json
    );

    debugPrint(response.data.toString());

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to update bus');
    }
  }


  Future<bool> init(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}bus/init", 
      data: json
    );

    debugPrint(response.data.toString());

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to init pod files');
    }
  }

}