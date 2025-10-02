# HabitoX - Application de Gestion d’Objectifs

🎯 **Philosophie : Un Objectif à la Fois**  
HabitoX mise sur une approche simple mais puissante : **un seul objectif actif à la fois**. Cela permet de se concentrer pleinement sur ce qui importe vraiment, sans dispersion.

---

## ✨ Fonctionnalités Principales

### 🎯 Gestion d’Objectifs Intelligente
- Un seul objectif actif à la fois  
- Objectifs personnalisables : titre, description, icône, couleur, durée cible  
- Système de grades : progression de **Novice** à **Légende**  
- Suivi des séries : jours consécutifs et meilleure série

### 📅 Calendrier & Suivi Visuel
- Visualisation de la progression via une heatmap (ou une grille visuelle)  
- Suivi intuitif de votre constance dans le temps  
- Interface permettant de voir les jours complétés ou manqués  
- Statistiques sur les séries et la cadence

### 🏆 Système de Badges & Gamification
- Badges à débloquer selon la progression  
- Collection visuelle des badges  
- Notifications ou célébrations lors des déblocages  
- Messages de motivation personnalisés  
- Statistiques détaillées pour encourager la constance

### 🎮 Gamification Avancée
- Grades progressifs (ex : Novice, Apprenti, Adepte, Expert, Maître, Grand Maître, Légende)  
- Encouragements et messages selon votre progression  
- Visualisation claire de vos performances, pour rester motivé  

### 📊 Interface & Expérience Utilisateur
- Design moderne et minimaliste  
- Navigation intuitive entre les vues Objectifs / Suivi / Badges  
- Adaptabilité et responsive pour divers formats d’écran  

---

## 🚀 Comment Commencer

1. **Créer un Objectif**  
   - Touche “Nouvel Objectif”  
   - Choisissez titre, description, icône, durée cible  
   - L’objectif devient actif automatiquement  

2. **Suivre votre Progression**  
   - Dans l’onglet *Suivi*, marquez vos sessions quotidiennes  
   - Voyez visuellement la progression via le calendrier / heatmap  
   - Suivez l’évolution de vos grades  

3. **Débloquer et Gérer les Badges**  
   - Atteignez les paliers requis pour débloquer des badges  
   - Suivez votre collection dans l’onglet dédié  
   - Recevez des notifications lors des nouveaux badges  

4. **Gérer vos Objectifs**  
   - Archivez ou supprimez les objectifs complétés  
   - Activez un nouvel objectif (l’ancien est désactivé automatiquement)  
   - Consultez vos statistiques globales et l’historique  

---

## 🏗️ Architecture Technique (suggestion / à compléter)

### Modèles de Données
- **Goal** : stocke les objectifs, progression, dates, séries  
- **Badge** : information sur les badges débloqués  
- **Progression / Heatmap** : structure de suivi des jours

### Services & Logique Métier
- `GoalService` : création, activation, mise à jour  
- `ProgressService` : mise à jour quotidienne, calcul des séries  
- `BadgeService` : logique de déblocage, liaison avec les objectifs  

### Interface & Widgets
- Vue principale de l’objectif actif  
- Widget / composant pour la heatmap ou grille visuelle  
- Vue badge / collection  
- Statistiques globales et historiques  

---

## 🔧 Technologies Utilisées
- **Flutter** : pour construire une application cross-platform  
- **Provider** (ou équivalent) pour la gestion d’état  
- **SharedPreferences** (ou stockage local équivalent)  
- UI moderne & minimaliste  

---

## 📱 Plateformes Cibles
- Android  
- iOS  
- Web  
- (Potentiellement Desktop selon les versions)  

---

## 🔮 Fonctionnalités Futures Possibles
- Synchronisation cloud / multi-appareils  
- Export / sauvegarde / restauration des données  
- Thèmes personnalisables  
- Défis / modes communautaires  
- Analytics avancés  
- Notifications intelligentes  

---

## 🤝 Contribution
Les contributions sont les bienvenues !  
N’hésitez pas à :  
- Signaler des bugs  
- Proposer des améliorations  
- Contribuer au code  
- Améliorer la documentation  

---

## 📄 Licence
Ce projet est sous licence **MIT**.  
Voir le fichier [LICENSE](./LICENSE) pour les détails.

---

## 🙏 Remerciements
Merci à la communauté Flutter, aux testeurs et contributeurs.  
HabitoX — transformez vos objectifs en succès, un jour à la fois.

