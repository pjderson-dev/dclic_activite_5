import 'package:flutter/material.dart';
import 'database_manager.dart';
import 'Modele/redacteur.dart';

void main() async {
  // Nécessaire pour s'assurer que tout est initialisé avant de lancer l'app
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MonApplication()); // [cite: 64]
}

// Widget racine StatelessWidget [cite: 64]
class MonApplication extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Rédacteurs',
      theme: ThemeData(primarySwatch: Colors.pink),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.pink,
          title: Text(
            'Gestion des rédacteurs',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ), // [cite: 78]
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {},
          ), // [cite: 80]
          actions: [
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
          ], // [cite: 82]
        ),
        body: RedacteursInterface(), // [cite: 83]
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Widget StatefulWidget pour l'interface [cite: 85]
class RedacteursInterface extends StatefulWidget {
  @override
  _RedacteursInterfaceState createState() => _RedacteursInterfaceState();
}

class _RedacteursInterfaceState extends State<RedacteursInterface> {
  final DatabaseManager _dbManager = DatabaseManager();

  // Contrôleurs pour les champs de texte [cite: 88, 94]
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();

  List<Redacteur> _redacteursList = [];

  @override
  void initState() {
    super.initState();
    // Charger les rédacteurs au démarrage [cite: 175]
    _dbManager.initialisation().then((_) {
      _chargerRedacteurs();
    });
  }

  void _chargerRedacteurs() async {
    final redacteurs = await _dbManager.getAllRedacteurs();
    setState(() {
      _redacteursList = redacteurs;
    });
  }

  void _ajouterRedacteur() async {
    if (_nomController.text.isNotEmpty &&
        _prenomController.text.isNotEmpty &&
        _emailController.text.isNotEmpty) {
      await _dbManager.insertRedacteur(
        Redacteur.sansId(
          nom: _nomController.text,
          prenom: _prenomController.text,
          email: _emailController.text,
        ),
      );
      _chargerRedacteurs();
      _nomController.clear();
      _prenomController.clear();
      _emailController.clear();
    }
  }

  void _supprimerRedacteur(int id) async {
    // Affiche une boîte de dialogue de confirmation avant la suppression [cite: 167]
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirmation'),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer ce rédacteur ?',
        ), // [cite: 168]
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await _dbManager.deleteRedacteur(id);
              Navigator.pop(context);
              _chargerRedacteurs();
            },
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _afficherDialogueModification(Redacteur redacteur) {
    // Affiche une boîte de dialogue pour la modification [cite: 144]
    final _editNomController = TextEditingController(text: redacteur.nom);
    final _editPrenomController = TextEditingController(text: redacteur.prenom);
    final _editEmailController = TextEditingController(text: redacteur.email);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Modifier Rédacteur'), // [cite: 154]
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _editNomController,
              decoration: InputDecoration(labelText: 'Nouveau Nom'),
            ),
            TextField(
              controller: _editPrenomController,
              decoration: InputDecoration(labelText: 'Nouveau Prénom'),
            ),
            TextField(
              controller: _editEmailController,
              decoration: InputDecoration(labelText: 'Nouvel Email'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ), // [cite: 161]
          TextButton(
            onPressed: () async {
              await _dbManager.updateRedacteur(
                Redacteur(
                  id: redacteur.id,
                  nom: _editNomController.text,
                  prenom: _editPrenomController.text,
                  email: _editEmailController.text,
                ),
              );
              Navigator.pop(context);
              _chargerRedacteurs();
            },
            child: Text('Enregistrer'), // [cite: 162]
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _nomController,
            decoration: InputDecoration(labelText: 'Nom'),
          ), // [cite: 87, 91]
          TextField(
            controller: _prenomController,
            decoration: InputDecoration(labelText: 'Prénom'),
          ),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ), // [cite: 102]
          SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: _ajouterRedacteur, // [cite: 139]
            icon: Icon(Icons.add),
            label: Text('Ajouter un Rédacteur'), // [cite: 103]
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            // Affiche la liste des rédacteurs [cite: 164]
            child: ListView.builder(
              itemCount: _redacteursList.length,
              itemBuilder: (context, index) {
                final redacteur = _redacteursList[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text('${redacteur.prenom} ${redacteur.nom}'),
                    subtitle: Text(redacteur.email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          // Icône de modification [cite: 166]
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              _afficherDialogueModification(redacteur),
                        ),
                        IconButton(
                          // Icône de suppression [cite: 166]
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _supprimerRedacteur(redacteur.id!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
