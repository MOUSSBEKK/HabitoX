# 🐛 Guide d'utilisation de la DebugScreen

## 📱 Accès à la page de debug

### Méthode 1 : Via l'écran de profil
1. Ouvrez l'application HabitoX
2. Allez dans l'onglet "Profil" 
3. Faites défiler vers le bas dans les paramètres
4. Cliquez sur "Debug (Test)" (icône de bug)

### Méthode 2 : Via la route directe
- Naviguez directement vers `/debug` dans votre application

## 🎯 Fonctionnalités disponibles

### 📊 Affichage des données actuelles
La page affiche en temps réel :
- **Avatar avec accessoires** : Visualise l'avatar actuel avec tous les accessoires débloqués
- **Niveau actuel** : Niveau et nom du niveau (Débutant, Déterminé, Elite, etc.)
- **XP total** : Points d'expérience totaux accumulés
- **XP dans le niveau** : Progression vers le prochain niveau
- **Jours consécutifs** : Nombre de jours consécutifs d'activité
- **Accessoires débloqués** : Liste de tous les accessoires d'avatar débloqués

### 🎮 Boutons de simulation

#### Simulation Jours Consécutifs
- **Ajouter 1 jour** : Ajoute 1 jour consécutif
- **Ajouter 5 jours** : Ajoute 5 jours consécutifs (débloque un nouvel accessoire)
- **Reset jours** : Remet les jours consécutifs à 0

#### Simulation XP
- **Ajouter 10 XP** : Ajoute 10 points d'expérience
- **Ajouter 100 XP** : Ajoute 100 points d'expérience (peut déclencher un level up)
- **Reset XP** : Remet l'expérience à 0 et le niveau à 1

#### Actions Complètes
- **Compléter un objectif** : Simule la completion d'un objectif de 7 jours (+7 XP)
- **Reset complet** : Remet TOUT le profil à zéro (irréversible)

### 🔄 Navigation
- **Bouton "Voir le profil"** (icône personnage) : Navigue vers l'écran de profil pour voir les changements en temps réel

## 🎨 Système d'accessoires d'avatar

### Déblocage automatique
Les accessoires se débloquent automatiquement tous les 5 jours consécutifs :

| Jours consécutifs | Accessoire débloqué |
|-------------------|---------------------|
| 5 jours           | Chapeau 🏆          |
| 10 jours          | Lunettes 👁️         |
| 15 jours          | Étoile ⭐           |
| 20 jours          | Couronne 👑         |
| 25 jours          | Ailes ✈️            |
| 30 jours          | Halo ☀️             |
| 35 jours          | Arc-en-ciel 🌈      |
| 40 jours          | Feu 🔥              |
| 45 jours          | Glace ❄️            |
| 50 jours          | Éclair ⚡           |

### Positionnement déterministe
- Les accessoires utilisent un seed basé sur l'ID utilisateur
- Le positionnement est déterministe (ne bouge pas à chaque rebuild)
- Légère rotation aléatoire pour un effet naturel

## 🧪 Tests recommandés

### Test 1 : Progression des accessoires
1. Reset les jours consécutifs
2. Ajoutez 5 jours → Vérifiez que le chapeau apparaît
3. Ajoutez 5 jours de plus → Vérifiez que les lunettes apparaissent
4. Naviguez vers le profil pour voir l'avatar en action

### Test 2 : Système de niveaux
1. Reset l'XP
2. Ajoutez 100 XP → Vérifiez le level up
3. Vérifiez que la barre de progression se met à jour
4. Naviguez vers le profil pour voir les changements

### Test 3 : Persistance des données
1. Modifiez les données (ajoutez XP, jours, etc.)
2. Fermez et rouvrez l'application
3. Vérifiez que les données sont conservées

## ⚠️ Avertissements

- **Reset complet** : Cette action est irréversible et supprime toutes les données du profil
- **Données persistantes** : Tous les changements sont sauvegardés automatiquement
- **Provider** : La page utilise Provider pour la gestion d'état, les changements sont immédiatement visibles

## 🔧 Dépannage

### Problème : Les changements ne s'affichent pas
- Vérifiez que Provider est correctement configuré
- Redémarrez l'application si nécessaire

### Problème : L'avatar ne se met pas à jour
- Vérifiez que les jours consécutifs sont bien mis à jour
- Naviguez vers le profil pour forcer le refresh

### Problème : Les données ne persistent pas
- Vérifiez que SharedPreferences fonctionne correctement
- Vérifiez les permissions de stockage

## 📝 Notes techniques

- **UserProfileService** : Toutes les modifications passent par le service
- **SharedPreferences** : Sauvegarde automatique des données
- **Provider** : Gestion d'état réactive
- **Material Design** : Interface utilisateur moderne et responsive

---

**🎉 La DebugScreen est maintenant prête à être utilisée pour tester et simuler facilement la progression utilisateur !**

