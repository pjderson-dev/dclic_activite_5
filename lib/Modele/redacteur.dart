class Redacteur {
  // Attributs de la classe [cite: 33]
  final int? id;
  final String nom;
  final String prenom;
  final String email;

  // Constructeur avec tous les attributs [cite: 54]
  Redacteur({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  // Constructeur sans l'attribut id [cite: 54]
  Redacteur.sansId({
    required this.nom,
    required this.prenom,
    required this.email,
  }) : id = null;

  // Méthode pour convertir un objet en Map, utile pour la BDD [cite: 55]
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }
}