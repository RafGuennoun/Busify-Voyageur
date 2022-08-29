class Driver {
  final String nom;
  final String prenom;
  final String birthday;
  final String id;

  Driver(this.nom, this.prenom, this.birthday, this.id);

  toJson(Driver driver){
    return {
      "nom" : driver.nom,
      "prenom" : driver.prenom,
      "birthday" : driver.birthday,
      "id" : driver.id
    };
  }

  factory Driver.fromJson(Map<String, dynamic> json){
    return Driver(
      json["nom"], 
      json["prenom"], 
      json["birthday"], 
      json["id"], 
    );
  }

  @override
  String toString() {
    return "nom = $nom, prenom = $prenom, birthday = $birthday, id = $id";
  }

}