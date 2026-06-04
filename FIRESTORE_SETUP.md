# Configuration Firebase et Firestore

## Sommaire
- Instructions d'application des règles Firestore
- Configuration Email/Password Authentication
- Initialisation de Firestore

## 1. Appliquer les règles Firestore

### Option A: Via Firebase Console

1. Accédez à [Firebase Console](https://console.firebase.google.com)
2. Sélectionnez le projet **trackerflutter-5ce6a**
3. Allez dans **Firestore Database** → **Règles**
4. Remplacez le contenu existant par celui du fichier `firestore.rules`
5. Cliquez sur **Publier**

### Option B: Via Firebase CLI

```bash
# Installer Firebase CLI si nécessaire
npm install -g firebase-tools

# Se connecter à Firebase
firebase login

# Déployer les règles
firebase deploy --only firestore:rules
```

## 2. Activer l'authentification Email/Password

1. Allez dans **Firebase Console** → **Authentication**
2. Cliquez sur l'onglet **Fournisseurs de connexion**
3. Cherchez **Email/Mot de passe**
4. Cliquez sur **Email/Mot de passe**
5. Activez **Email/Mot de passe**
6. Cliquez sur **Enregistrer**

## 3. Vérifier la configuration Firestore

1. Allez dans **Firestore Database**
2. La base de données doit être en mode de production
3. Vérifiez que les règles de sécurité sont correctes (voir étape 1)

## 4. Structure Firestore attendue

Après utilisation de l'application, la structure sera:

```
users/
  {uid}/
    vehicles/
      {vehicleId}/
        - id
        - name
        - brand
        - model
        - registrationNumber
        - year
        - currentMileage
        - createdAt
        - updatedAt
    fuelEntries/
      {fuelEntryId}/
        - id
        - vehicleId
        - date
        - liters
        - totalAmount
        - mileage
        - notes (optionnel)
        - createdAt
        - updatedAt
    maintenanceCategories/
      {categoryId}/
        - id
        - name
        - description
        - createdAt
        - updatedAt
    maintenances/
      {maintenanceId}/
        - id
        - vehicleId
        - categoryId
        - categoryName
        - date
        - cost
        - mileage
        - description
        - createdAt
        - updatedAt
```

## 5. Sécurité des données

- **Chaque utilisateur ne peut accéder qu'à ses propres données** via son `uid`
- Les règles Firestore garantissent que `request.auth.uid == uid`
- Tous les appels utilisent le `uid` de l'utilisateur authentifié
- **Aucune donnée ne peut être mixée entre utilisateurs**

## 6. Tester une première utilisatrice

1. Lancez l'application
2. Créez un compte avec email et mot de passe
3. Ajoutez un véhicule
4. Enregistrez un plein
5. Vérifiez dans Firestore que les données sont correctement stockées sous `users/{uid}`

## Troubleshooting

### Erreur: "You do not have permission to perform this action"
- Vérifiez que l'utilisateur est authentifié
- Vérifiez que les règles Firestore ont été publiées
- Vérifiez que `request.auth.uid` correspond à l'UID de l'utilisateur

### Erreur: "Authentication failed"
- Vérifiez que Email/Password est activé dans Firebase Console
- Vérifiez les identifiants saisis

### Erreur: "PERMISSION_DENIED"
- Assurez-vous d'être sur une route protégée après authentification
- Redémarrez l'application
- Vérifiez les logs console du navigateur
