# 🎨 Design System - HabitoX

## Vue d'ensemble

HabitoX utilise un design épuré et minimaliste basé sur une palette de **trois couleurs principales** pour créer une expérience utilisateur cohérente et moderne.

## 🎨 Palette de couleurs

### Couleurs principales
- **#85B8CB** - Bleu clair (Light Color)
  - Utilisé pour : arrière-plans, fonds, bordures, éléments de surface
  - Représente : la légèreté, l'espace, la clarté, la sérénité

- **#A7C6A5** - Vert clair (Primary Color)
  - Utilisé pour : onglets, boutons, éléments d'accent, liens
  - Représente : l'action, l'engagement, la progression, la nature

- **#1F4843** - Vert foncé (Dark Color)
  - Utilisé pour : **TOUT le texte** (titres, contenu, labels, descriptions)
  - Représente : la stabilité, la lisibilité, la hiérarchie, la profondeur

### Couleurs dérivées
- **#B8D1B6** - Vert plus clair (Primary Light)
- **#8FB28D** - Vert plus foncé (Primary Dark)
- **#2A5A55** - Version plus claire du vert foncé pour texte secondaire
- **#3A6A65** - Version encore plus claire pour texte muted

## 🧩 Composants

### Boutons
- **Bouton principal** : Vert clair (#A7C6A5) avec texte vert foncé (#1F4843)
- **Bouton secondaire** : Bordure bleue claire (#85B8CB) avec texte vert foncé (#1F4843)
- **Bouton texte** : Texte vert foncé (#1F4843) sans arrière-plan
- **Rayon de bordure** : 16px pour une apparence moderne

### Cartes
- **Arrière-plan** : Blanc pur
- **Bordures** : Bleu clair (#85B8CB) avec opacité 0.3
- **Rayon de bordure** : 20px pour une apparence douce
- **Ombres** : Subtiles avec opacité 0.1 en vert foncé (#1F4843)

### Inputs
- **Arrière-plan** : Bleu clair (#85B8CB) avec opacité 0.2
- **Bordure normale** : Bleu clair (#85B8CB) avec opacité 0.5
- **Bordure focus** : Vert clair (#A7C6A5) avec épaisseur 2px
- **Rayon de bordure** : 16px

### Typographie
- **Tous les textes** : Vert foncé (#1F4843) pour une cohérence maximale
- **Titres** : Vert foncé (#1F4843) avec poids 600
- **Texte principal** : Vert foncé (#1F4843)
- **Texte secondaire** : Version plus claire du vert foncé (#2A5A55)
- **Texte muted** : Version encore plus claire du vert foncé (#3A6A65)

### Onglets
- **Arrière-plan** : Bleu clair (#85B8CB)
- **Onglet actif** : Vert clair (#A7C6A5)
- **Onglet inactif** : Bleu clair (#85B8CB)
- **Texte des onglets** : Vert foncé (#1F4843)

## 📱 Écrans et widgets

### Écran d'accueil
- Arrière-plan subtil avec bleu clair (#85B8CB)
- Navigation inférieure avec vert clair (#A7C6A5) pour l'élément actif
- Ombres douces sur les conteneurs en vert foncé (#1F4843)

### Écran des objectifs
- Header avec bleu clair (#85B8CB) et vert clair (#A7C6A5) pour l'icône
- Statistiques unifiées avec la palette verte
- Bouton d'ajout en vert clair (#A7C6A5)
- **Tout le texte en vert foncé (#1F4843)**

### Écran des badges
- Design cohérent avec l'écran des objectifs
- Utilisation du vert clair (#A7C6A5) pour les éléments d'accent
- Arrière-plans en bleu clair (#85B8CB) pour la légèreté
- **Tout le texte en vert foncé (#1F4843)**

### Écran de profil
- Header avec bleu clair (#85B8CB) et vert clair (#A7C6A5)
- Sections unifiées avec la palette de couleurs
- Icônes et éléments d'action en vert clair (#A7C6A5)
- **Tout le texte en vert foncé (#1F4843)**

## 🔧 Utilisation technique

### Import des couleurs
```dart
import 'constants/app_colors.dart';

// Utilisation
Container(
  color: AppColors.lightColor,        // #85B8CB pour fonds
  child: Text('Texte', style: TextStyle(color: AppColors.darkColor)), // #1F4843 pour texte
)
```

### Classes de couleurs disponibles
- `AppColors` - Couleurs principales et utilitaires
- `ComponentColors` - Couleurs spécifiques aux composants
- `StatusColors` - Couleurs pour les états et statuts

### Méthodes utilitaires
```dart
// Opacités
AppColors.primaryWithOpacity(0.5)     // #A7C6A5 avec opacité
AppColors.lightWithOpacity(0.3)       // #85B8CB avec opacité
AppColors.darkWithOpacity(0.7)        // #1F4843 avec opacité
```

## 🎯 Principes de design

### 1. Minimalisme
- Utilisation de seulement 3 couleurs principales
- Espacement généreux et aéré
- Typographie claire et lisible

### 2. Cohérence
- **TOUT le texte utilise la même couleur (#1F4843)**
- Même palette sur tous les écrans
- Composants réutilisables avec styles unifiés
- Hiérarchie visuelle claire

### 3. Accessibilité
- Contraste élevé entre texte vert foncé et arrière-plans clairs
- Tailles de police appropriées
- Couleurs distinctes pour les états

### 4. Modernité
- Rayons de bordure généreux
- Ombres subtiles et élégantes
- Espacement cohérent et équilibré

## 🌿 Palette naturelle

La nouvelle palette s'inspire de la nature :
- **#85B8CB** : Bleu ciel apaisant pour les fonds
- **#A7C6A5** : Vert feuille doux pour les actions
- **#1F4843** : Vert forêt profond pour la lisibilité

## 📋 Checklist d'implémentation

- [x] Thème global dans `main.dart`
- [x] Écran d'accueil et navigation
- [x] Écran des objectifs
- [x] Écran des badges
- [x] Écran de profil
- [x] Widgets principaux
- [x] Constantes de couleurs centralisées
- [x] Documentation du design system
- [x] **Nouvelle palette de couleurs appliquée**

## 🚀 Prochaines étapes

1. **Tests visuels** : Vérifier la cohérence sur différents appareils
2. **Accessibilité** : Valider les contrastes avec la nouvelle palette
3. **Performance** : Optimiser le rendu des composants
4. **Feedback utilisateur** : Recueillir les retours sur le nouveau design

---

*Design System mis à jour pour HabitoX - Application de suivi d'objectifs et de développement personnel*
