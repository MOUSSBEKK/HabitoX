# HabitoX - Application de Gestion d'Objectifs

## 🎯 Philosophie : Un Objectif à la Fois

HabitoX est conçu autour d'une philosophie simple mais puissante : **un seul objectif actif à la fois**. Cette approche vous permet de vous concentrer pleinement sur ce qui compte vraiment, évitant la dispersion et maximisant vos chances de succès.

## ✨ Fonctionnalités Principales

### 🎯 Gestion d'Objectifs Intelligente
- **Un seul objectif actif** : Évitez la dispersion en vous concentrant sur un seul objectif
- **Objectifs personnalisables** : Titre, description, icône, couleur et durée cible
- **Système de grades** : Progression de Novice à Légende avec des récompenses visuelles
- **Suivi des séries** : Gardez une trace de vos jours consécutifs et de votre meilleure série

### 📅 Calendrier Heatmap avec Formes Aléatoires
- **10 formes de calendrier uniques** : Soucoupe volante, fusée, étoile, cœur, diamant, couronne, papillon, arbre, fleur, éclair
- **Génération aléatoire** : Chaque forme a un motif unique et un nombre de jours spécifique
- **Visualisation intuitive** : Grille 7x7 avec progression en temps réel
- **Formes débloquables** : Complétez 100% d'un calendrier pour débloquer sa forme

### 🏆 Système de Badges Collectibles
- **Badges uniques** : Chaque forme de calendrier débloquée devient un badge
- **Collection complète** : Collectez tous les badges pour devenir un maître des objectifs
- **Progression visuelle** : Suivez votre collection avec des statistiques détaillées
- **Célébration automatique** : Notifications spéciales lors du déblocage de badges

### 🎮 Gamification Avancée
- **Grades progressifs** : 
  - 🥉 Novice (0+ jours)
  - 🥈 Apprenti (10+ jours)
  - 🥇 Adepte (25+ jours)
  - 💎 Expert (50+ jours)
  - 👑 Maître (100+ jours)
  - 🌟 Grand Maître (200+ jours)
  - 🔥 Légende (500+ jours)
- **Messages de motivation** : Encouragements personnalisés selon votre progression
- **Statistiques détaillées** : Suivi complet de vos performances

### 📊 Interface Professionnelle
- **Design moderne** : Interface Material Design 3 avec animations fluides
- **Navigation intuitive** : Onglets séparés pour le suivi et la gestion
- **Responsive** : S'adapte parfaitement à tous les écrans
- **Thème cohérent** : Couleurs et styles harmonisés

## 🚀 Comment Commencer

### 1. Créer un Objectif
- Appuyez sur "Nouvel Objectif" dans l'onglet Objectifs
- Choisissez un titre, une description et une icône
- Définissez le nombre de jours cible
- Votre objectif devient automatiquement actif

### 2. Suivre votre Progression
- Utilisez l'onglet "Suivi" pour voir votre objectif actif
- Marquez vos sessions quotidiennes avec le bouton "Marquer session"
- Suivez votre progression vers le prochain grade
- Visualisez votre calendrier heatmap actuel

### 3. Débloquer des Badges
- Chaque forme de calendrier a un nombre de jours spécifique
- Atteignez 100% de progression pour débloquer le badge
- Collectez tous les badges pour compléter votre collection
- Changez de forme de calendrier à tout moment

### 4. Gérer vos Objectifs
- Archivez ou supprimez les objectifs terminés
- Activez un nouvel objectif (désactive automatiquement l'ancien)
- Consultez vos statistiques globales
- Gérez votre collection de badges

## 🏗️ Architecture Technique

### Modèles de Données
- **Goal** : Objectifs avec progression, grades et séries
- **CalendarShape** : Formes de calendrier avec motifs aléatoires
- **Badge** : Badges débloqués basés sur les formes de calendrier

### Services
- **GoalService** : Gestion des objectifs et de la progression
- **CalendarService** : Gestion des formes de calendrier et badges
- **BadgeSyncService** : Synchronisation entre objectifs et badges

### Interface Utilisateur
- **ActiveGoalWidget** : Affichage de l'objectif actif
- **CalendarHeatmapWidget** : Visualisation du calendrier heatmap
- **BadgesWidget** : Collection et gestion des badges
- **GlobalStatsWidget** : Statistiques globales

## 🔧 Technologies Utilisées

- **Flutter** : Framework de développement cross-platform
- **Provider** : Gestion d'état et injection de dépendances
- **SharedPreferences** : Persistance locale des données
- **Material Design 3** : Système de design moderne

## 📱 Plateformes Supportées

- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Desktop (Windows, macOS, Linux)

## 🎨 Personnalisation

### Formes de Calendrier
- **Génération aléatoire** : Chaque forme est unique
- **Couleurs dynamiques** : Palette de couleurs variée
- **Motifs personnalisés** : Grilles 7x7 avec jours actifs/inactifs

### Badges
- **Emojis uniques** : Chaque forme a son emoji caractéristique
- **Noms personnalisés** : Badges nommés selon la forme débloquée
- **Collection visuelle** : Affichage en grille avec statuts

## 🔮 Fonctionnalités Futures

- [ ] Synchronisation cloud
- [ ] Partage de progression
- [ ] Défis communautaires
- [ ] Notifications intelligentes
- [ ] Analytics avancés
- [ ] Thèmes personnalisables
- [ ] Export de données

## 🤝 Contribution

Les contributions sont les bienvenues ! N'hésitez pas à :
- Signaler des bugs
- Proposer des améliorations
- Contribuer au code
- Améliorer la documentation

## 📄 Licence

Ce projet est sous licence MIT. Voir le fichier LICENSE pour plus de détails.

## 🙏 Remerciements

Merci à la communauté Flutter et à tous ceux qui contribuent à l'amélioration de cette application.

---

**HabitoX** - Transformez vos objectifs en succès, un jour à la fois ! 🚀
