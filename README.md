# Tracker Flutter

Application mobile SaaS de suivi de véhicules, de consommation de gasoil et de maintenance.

## Fonctionnalités principales

### 🔐 Authentification
- Création de compte avec email et mot de passe
- Connexion sécurisée
- Gestion de session persistante
- Profil utilisateur

### 🚗 Gestion des véhicules
- Ajouter, modifier et supprimer des véhicules
- Consulter les détails d'un véhicule
- Affichage du kilométrage et informations techniques

### ⛽ Suivi du carburant
- Enregistrement des pleins
- Calcul automatique du prix par litre
- Historique des pleins filtrable
- Notes et commentaires

### 🔧 Suivi de la maintenance
- Gestion des catégories de maintenance
- Enregistrement des opérations
- Historique complet avec coûts
- Filtrage par date et catégorie

### 📊 Dashboard
- Statistiques mensuelles
- Répartition des dépenses
- Consommation en litres
- Dernières opérations
- Vue d'ensemble multi-véhicule

## Stack technologique

- **Framework**: Flutter
- **Langage**: Dart
- **Navigation**: GoRouter
- **Gestion d'état**: Riverpod
- **Backend**: Firebase
- **Base de données**: Cloud Firestore
- **Authentification**: Firebase Authentication

## Installation

### Prérequis
- Flutter SDK ^3.11.5
- Dart SDK ^3.11.5
- Git

### Étapes

```bash
# Cloner le repository
git clone https://github.com/elguzoulimalak/tracker_flutter.git
cd tracker_flutter

# Installer les dépendances
flutter pub get

# Lancer l'application
flutter run

# Lancer sur Chrome (Web)
flutter run -d chrome

# Lancer sur Android
flutter run -d android

# Lancer sur iOS
flutter run -d ios
```

## Configuration Firebase

1. **Activer Email/Password Authentication**
   - Console Firebase → Authentication → Email/Password

2. **Appliquer les règles Firestore**
   - Voir `FIRESTORE_SETUP.md`

3. **Vérifier la configuration Firestore**
   - Mode production activé
   - Règles sécurisées appliquées

## Structure du projet

```
lib/
├── core/          # Thème, routeur, utilitaires
├── features/      # Fonctionnalités (auth, vehicles, fuel, maintenance, dashboard)
└── shared/        # Widgets partagés
```

Voir `PROJECT_REPORT.md` pour plus de détails.

## Tests

```bash
# Exécuter tous les tests
flutter test

# Analyser le code
flutter analyze

# Formatter le code
dart format .
```

## Documentation

- [PROJECT_REPORT.md](PROJECT_REPORT.md) - Rapport complet du projet
- [FIRESTORE_SETUP.md](FIRESTORE_SETUP.md) - Configuration Firestore et règles de sécurité
- [firestore.rules](firestore.rules) - Règles Firestore

## Architecture

L'application suit le pattern:
```
Presentation → Providers (Riverpod) → Services → Firebase/Firestore → Models
```

Chaque fonctionnalité est isolée dans son propre module avec:
- Models: Structures de données
- Services: Logique métier
- Providers: Gestion d'état
- Screens: Interface utilisateur

## Sécurité

- ✅ Authentification Firebase
- ✅ Isolation complète des données par utilisateur
- ✅ Règles Firestore en mode production
- ✅ Pas de données mixées entre utilisateurs
- ✅ HTTPS pour toutes les connexions

## Développement

### Ajouter une nouvelle fonctionnalité

1. Créer la structure dans `lib/features/nouvelle_fonction`
2. Implémenter le modèle
3. Créer le service Firestore
4. Ajouter les providers Riverpod
5. Créer les écrans
6. Ajouter les routes dans `app_router.dart`
7. Écrire les tests

### Commandes utiles

```bash
# Générer les fichiers (si utilisant build_runner)
flutter pub run build_runner build

# Nettoyer
flutter clean

# Obtenir les dépendances
flutter pub get

# Vérifier les problèmes
flutter analyze --no-fatal-infos
```

## Contribution

Les contributions sont bienvenues! Veuillez:
1. Fork le repository
2. Créer une branche (`git checkout -b feature/AmazingFeature`)
3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)
4. Push vers la branche (`git push origin feature/AmazingFeature`)
5. Ouvrir une Pull Request

## Licence

Ce projet est sous licence MIT.

## Support

Pour les problèmes:
- Ouvrir une issue sur GitHub
- Consulter la documentation
- Vérifier les logs Firestore

## Auteur

Développé comme projet d'études en Mobile Development.

---

**Prêt à démarrer?** Consultez [FIRESTORE_SETUP.md](FIRESTORE_SETUP.md) pour la configuration initiale.

