class Node {
  final int id;
  final String name;
  final String network;
  String? highway;
  String? bus;
  final double lat;
  final double lon;

  Node(this.id, this.name, this.network, this.lat, this.lon, [this.highway, this.bus]);

  toJson(Node node){
    return {
      "id" : node.id,
      "name" : node.name,
      "network" : node.network,
      "lat" : node.lat,
      "lon" : node.lon
    };
  }

  factory Node.fromJson(Map<String, dynamic> json){
    return Node(
      json["id"], 
      json["name"], 
      json["network"], 
      json["lat"], 
      json["lon"] 
    );
  }

  factory Node.fromOSM(Map<String, dynamic> json){
    return Node(
      json["elements"][0]["id"], 
      json["elements"][0]["tags"]["name"], 
      json["elements"][0]["tags"]["network"], 
      json["elements"][0]["lat"], 
      json["elements"][0]["lon"], 
      json["elements"][0]["tags"]["highway"], 
      json["elements"][0]["tags"]["bus"], 
    );
  }

  @override
  String toString() {
    return """ 
      id = $id 
      name = $name 
      network = $network 
      lat = $lat 
      lon = $lon 
      highway = $highway 
      bus = $bus 
    """;
  }

}