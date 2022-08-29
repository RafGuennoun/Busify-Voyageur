class Constants {

  static const String api = "https://pfe-m2-api.herokuapp.com/";
  static const String relationOSM = "https://www.openstreetmap.org/api/0.6/relation/" ;
  static const String nodeOSM = "https://www.openstreetmap.org/api/0.6/node/" ;

  getAPI(){
    return api;
  }

  getRelationOSM(){
    return relationOSM;
  }

  getNodeOSM(){
    return nodeOSM;
  }
  
}