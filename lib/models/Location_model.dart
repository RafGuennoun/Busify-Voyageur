class LocationModel {
  final String lat;
  final String lon;
  final String track;


  LocationModel(this.lat, this.lon, this.track);

  toJson(LocationModel location){
    return {
      "lat" : location.lat,
      "lon" : location.lon,
      "track" : location.track
    };
  }

  factory LocationModel.fromJson(Map<String, dynamic> json){
    return LocationModel(
      json["lat"], 
      json["lon"],
      json["track"] 
    );
  }

  @override
  String toString() {
    return "lat = $lat / lon = $lon / track = $track";
  }

  String getTrack() {
    return track;
  }


}