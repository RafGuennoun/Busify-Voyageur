import 'package:busify_voyageur/Utils/constants.dart';
import 'package:busify_voyageur/controllers/Relation_controller.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:dio/dio.dart';


class NodeController {

  final String osm = Constants().getNodeOSM();

  Future<Node> getNodeOSM(int id) async {
    Response response;
    var dio = Dio();
    response = await dio.get("$osm${id.toString()}.json");
    // response = await dio.get("${osm}7996451.json");
    if (response.statusCode == 200) {
      Map<String, dynamic> res = (response.data) as Map<String, dynamic> ; 
      Node node = Node.fromOSM(res);
      return node;
      
    } else {
      throw Exception('Failed to get node from OSM');
    }
  }

  Future<bool> isBusStop(int id) async {
    Response response;
    var dio = Dio();
    response = await dio.get("$osm${id.toString()}.json");
    // response = await dio.get("${osm}7996451.json");
    if (response.statusCode == 200) {
      Map<String, dynamic> res = (response.data) as Map<String, dynamic> ; 
      if (
        (res["elements"][0]["tags"]["bus"] == "yes") || 
        (res["elements"][0]["tags"]["highway"] == "bus_stop") 
      ){
        return true;
      }
      return false;
      
    } else {
      throw Exception('Failed to get node from OSM');
    }
  }

  Future<List<Node>> buildNodes(int id) async {
    RelationController relRepo = RelationController();

    List<Node> nodeObjects = [];

    List<int> nodes = await relRepo.getRelationNodes(id);
    for (int nodeID in nodes) {
      Node node = await getNodeOSM(nodeID);
      nodeObjects.add(node);
    }

    return nodeObjects;
  }





}