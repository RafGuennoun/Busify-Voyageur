class Relation {
  final String id;
  final String name;
  final String network;
  final String from; 
  final String to;

  Relation(this.id, this.name, this.network, this.from, this.to);

  toJson(Relation relation){
    return {
      "id" : relation.id,
      "name" : relation.name,
      "network" : relation.network,
      "from" : relation.from,
      "to" : relation.to
    };
  }

  factory Relation.fromJson(Map<String, dynamic> json){
    return Relation(
      json["id"], 
      json["name"], 
      json["network"], 
      json["from"], 
      json["to"] 
    );
  }

  factory Relation.fromOSM(Map<String, dynamic> json){
    return Relation(
      json["elements"][0]["id"].toString(), 
      json["elements"][0]["tags"]["name"], 
      json["elements"][0]["tags"]["network"], 
      json["elements"][0]["tags"]["from"], 
      json["elements"][0]["tags"]["to"], 
    );
  }

  @override
  String toString() {
    return """ 
      id = $id 
      name = $name 
      network = $network 
      from = $from 
      to = $to 
    """;
  }
}