class Bus {
  final String name;
  final String marque; 
  final String matricule;
  final String line;
  final String activity;

  Bus(this.name, this.marque, this.matricule, this.line, this.activity);

  toJson(Bus bus){
    return {
      "nom" : bus.name,
      "marque" : bus.marque,
      "matricule" : bus.matricule,
      "line" : bus.line,
      "activity" : bus.activity
    };
  }

  factory Bus.fromJson(Map<String, dynamic> json){
    return Bus(
      json["nom"], 
      json["marque"], 
      json["matricule"], 
      json["line"], 
      json["activity"] 
    );
  }

  @override
  String toString() {
    return "nom = $name, marque = $marque, matricule = $matricule, activity = $activity, line = $line ";
  }

  String getLine(){
    return line;
  }

  String getActivity(){
    return activity;
  }

}