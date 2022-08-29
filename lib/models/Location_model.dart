class LocationModel {
  final String lat;
  final String lon;

  LocationModel(this.lat, this.lon);

  toJson(LocationModel location){
    return {
      "lat" : location.lat,
      "lon" : location.lon
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json){
    return LocationModel(
      json["lat"], 
      json["lon"] 
    );
  }

  @override
  String toString() {
    return "lat = $lat / lon = $lon";
  }
}