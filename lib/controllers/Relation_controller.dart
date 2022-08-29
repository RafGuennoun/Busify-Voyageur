import 'package:busify_voyageur/Utils/constants.dart';
import 'package:busify_voyageur/models/Realtion_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


class RelationController {

  final String api = Constants().getAPI();
  final String osm = Constants().getRelationOSM();

  Future<List<String>> relations() async {
    Response response;
    var dio = Dio();
    response = await dio.get("${api}line/lines");
    if (response.statusCode == 200) {
      String l = response.data;
      l = l.substring(1,l.length-1);
      List<String> lines = l.split(',');
      return lines;
    } else {
      throw Exception('Failed to get ralations');
    }
  }
  
  Future<Relation> getRelation(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}line/get", 
      data: json
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> res = (response.data) as Map<String, dynamic> ; 
      Relation relation = Relation.fromJson(res);
      return relation;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to get bus ralation.');
    }
  }

  Future<bool> addRelation(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}line/add", 
      data: json
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to add relation.');
    }
  }

  Future<bool> addRelationToDirectory(Map<String, dynamic> json) async {
    Response response;
    var dio = Dio();
    response = await dio.post(
      "${api}line/add_directory", 
      data: json
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      debugPrint(response.statusCode.toString());
      throw Exception('Failed to add relation to directory.');
    }
  }

  Future<Relation> getRelationOSM(int id) async {
    Response response;
    var dio = Dio();
    response = await dio.get("$osm${id.toString()}.json");
    // response = await dio.get("${osm}7996451.json");
    if (response.statusCode == 200) {
      Map<String, dynamic> res = (response.data) as Map<String, dynamic> ; 
      Relation relation = Relation.fromOSM(res);
      return relation;
    } else {
      throw Exception('Failed to get ralation from OSM');
    }
  }

  Future<List<int>> getRelationNodes(int id) async {
    Response response;
    var dio = Dio();
    response = await dio.get("$osm${id.toString()}.json");
    // response = await dio.get("${osm}7996451.json");
    if (response.statusCode == 200) {
      List<int> nodeIds = [];
      Map<String, dynamic> res = (response.data) as Map<String, dynamic>;
      List members = res["elements"][0]["members"];
      
      for (var element in members) {
        if (element["type"] == "node") {
          nodeIds.add(element["ref"]);
        }
      }

      return nodeIds;
    } else {
      throw Exception('Failed to get ralation from OSM');
    }
  }




}