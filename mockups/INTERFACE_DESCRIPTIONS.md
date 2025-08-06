# 📱 INTERFACE MOCKUPS - LifeCompanion

## Descriptions détaillées des écrans

---

## 🏠 **DASHBOARD PRINCIPAL**

### **Vue d'ensemble**

```yaml
Layout: Grid responsive 12 colonnes
Header: Logo + Navigation + Profil utilisateur
Sidebar: Menu principal (Dashboard, Devices, Analytics, Settings)
Main Content: Cards avec métriques temps réel
Footer: Status système + liens utiles
```

### **Composants principaux**

#### **1. Métriques Environnementales (Row 1)**

```markdown
┌─────────────┬─────────────┬─────────────┬─────────────┐
│ Temperature │ Humidity │ Air Quality│ Light Level│
│ 23.5°C │ 45.2% │ Excellent │ Bright │
│ ↗️ +0.3° │ ↘️ -1.1% │ 420 PPM │ 850 lux │
│ Comfortable│ Optimal │ CO2 Good │ Daylight │
└─────────────┴─────────────┴─────────────┴─────────────┘
```

#### **2. Activité Actuelle (Row 2, Col 1-8)**

```markdown
┌────────────────────────────────────────────────────────────┐
│ 🏢 ACTIVITÉ DÉTECTÉE: Travail │
│ ⏱️ Depuis: 09:15 (2h 45min) │
│ 🎯 Confiance: 89% │
│ 📊 Conditions optimales pour productivité │
│ │
│ [Graphique Timeline des 6 dernières heures] │
│ 09:00 ████████████ Travail │
│ 12:00 ███ Pause │
│ 13:00 ████████████ Travail │
└────────────────────────────────────────────────────────────┘
```

#### **3. Alertes & Recommandations (Row 2, Col 9-12)**

```markdown
┌─────────────────────────────┐
│ 🔔 ALERTES (2) │
│ │
│ ⚠️ CO2 en augmentation │
│ Aération recommandée │
│ [Programmer] [Ignorer] │
│ │
│ 💡 CONSEIL │
│ Pause recommandée dans │
│ 45 minutes pour │
│ maintenir focus │
└─────────────────────────────┘
```

#### **4. Graphiques Analytics (Row 3)**

```markdown
┌────────────────────────────────────────────────────────────┐
│ 📈 TENDANCES JOURNALIÈRES │
│ │
│ [Graphique multi-lignes: Temp, Humidité, CO2 sur 24h] │
│ Température: ████████████████████████████████████ │
│ Humidité: ████████████████████████████████████ │
│ CO2: ████████████████████████████████████ │
│ │
│ 🎯 Zones de confort respectées à 87% aujourd'hui │
└────────────────────────────────────────────────────────────┘
```

---

## 📱 **MOBILE APP FLUTTER**

### **1. Écran d'accueil**

```yaml
AppBar:
  - Title: "LifeCompanion"
  - Actions: Notifications (badge: 2), Profile

Body:
  - Status Cards (3x Grid)
    * Température actuelle avec gauge
    * Activité en cours avec timer
    * Score confort journalier

  - Quick Actions (Row)
    * Rafraîchir données
    * Voir historique
    * Paramètres rapides

  - Recent Activity Timeline
    * 5 dernières activités détectées
    * Swipe pour plus de détails

BottomNavBar:
  - Home, Devices, Analytics, Profile
```

### **2. Écran Devices**

```yaml
AppBar: "Mes Appareils" + Add Device FAB

Body:
  - Device Cards (ListView)
    * Nom + Statut (online/offline)
    * Dernière lecture + timestamp
    * Niveau batterie + signal
    * Tap pour détails

  - Empty State si aucun device
    * Illustration + "Ajouter votre premier capteur"
    * CTA Button vers setup

Device Detail Modal:
  - Informations techniques
  - Graphiques données récentes
  - Configuration paramètres
```

### **3. Écran Analytics**

```yaml
Tabs: Aujourd'hui | Semaine | Mois

Content:
  - Summary Cards
    * Temps par activité (pie chart)
    * Score environnemental moyen
    * Nombre d'alertes

  - Interactive Charts
    * Line chart températures
    * Bar chart activités par heure
    * Heatmap confort par pièce

  - Insights personnalisés
    * "Vous êtes plus productif à 21°C"
    * "Votre sommeil s'améliore avec moins de bruit"
```

---

## 💻 **WEB DASHBOARD**

### **1. Layout Principal**

```yaml
Header (Fixed):
  - Logo LifeCompanion
  - Search bar
  - Notifications dropdown
  - User menu (avatar + nom)

Sidebar (Collapsible):
  - Dashboard (active)
  - Devices Management
  - Analytics & Reports
  - ML Classification
  - System Settings
  - User Preferences

Main Content (Scrollable):
  - Breadcrumb navigation
  - Page title + actions
  - Content cards/widgets
```

### **2. Page Analytics Avancée**

```yaml
Filters Bar:
  - Date range picker
  - Device selector (multi)
  - Activity type filter
  - Export options

Widgets Grid: 1. KPI Cards (4x row)
  - Total readings today
  - Classification accuracy
  - Average comfort score
  - Active devices

  2. Time Series Charts (2x2 grid)
  - Environmental trends
  - Activity patterns
  - Comfort zones
  - Prediction models

  3. Data Tables
  - Recent classifications
  - Device status
  - Alert history
```

### **3. Device Management**

```yaml
Header Actions:
  - Add Device
  - Bulk Actions
  - Import/Export
  - Settings

Device Grid/List Toggle:
  - Card view: Visual avec status
  - Table view: Détails techniques

Device Card Content:
  - Device image/icon
  - Name + Location
  - Status indicator (green/red/orange)
  - Last seen timestamp
  - Quick actions (edit, delete, configure)
  - Mini chart dernières lectures

Filters Sidebar:
  - Status (all, online, offline, maintenance)
  - Room/Location
  - Device type
  - Battery level
```

---

## 🎨 **DESIGN SYSTEM**

### **Couleurs**

```yaml
Primary: #2563EB (Blue 600)
Secondary: #10B981 (Green 500)
Success: #059669 (Green 600)
Warning: #D97706 (Orange 600)
Error: #DC2626 (Red 600)
Info: #0891B2 (Cyan 600)

Neutrals:
  - Gray 50: #F9FAFB (backgrounds)
  - Gray 100: #F3F4F6 (borders)
  - Gray 500: #6B7280 (text secondary)
  - Gray 900: #111827 (text primary)
```

### **Typography**

```yaml
Headings: Inter (Google Fonts)
  - H1: 2.25rem (36px) - Bold
  - H2: 1.875rem (30px) - Semibold
  - H3: 1.5rem (24px) - Medium
  - H4: 1.25rem (20px) - Medium

Body: Inter Regular
  - Large: 1.125rem (18px)
  - Base: 1rem (16px)
  - Small: 0.875rem (14px)
  - XS: 0.75rem (12px)
```

### **Composants**

```yaml
Cards:
  - Border radius: 8px
  - Shadow: 0 1px 3px rgba(0,0,0,0.1)
  - Padding: 1.5rem (24px)

Buttons:
  - Primary: Blue background, white text
  - Secondary: Gray border, gray text
  - Border radius: 6px
  - Padding: 0.5rem 1rem

Inputs:
  - Border: Gray 300
  - Focus: Blue 500 border
  - Border radius: 6px
  - Padding: 0.75rem
```

---

## 📊 **EXEMPLES DE DONNÉES**

### **Dashboard Metrics**

```json
{
  "current_temperature": 23.5,
  "temperature_trend": "+0.3",
  "humidity": 45.2,
  "humidity_trend": "-1.1",
  "co2_ppm": 420,
  "air_quality": "excellent",
  "light_lux": 850,
  "light_level": "bright",
  "current_activity": {
    "type": "work",
    "confidence": 0.89,
    "duration_minutes": 165,
    "start_time": "09:15"
  },
  "comfort_score": 8.7,
  "alerts_count": 2
}
```

### **Device Status**

```json
{
  "devices": [
    {
      "id": "device_001",
      "name": "Capteur Salon",
      "status": "online",
      "battery": 87,
      "signal": -45,
      "last_seen": "2024-01-15T12:30:00Z",
      "location": "salon"
    },
    {
      "id": "device_002",
      "name": "Capteur Chambre",
      "status": "offline",
      "battery": 23,
      "signal": -67,
      "last_seen": "2024-01-15T08:15:00Z",
      "location": "bedroom"
    }
  ]
}
```

---

## 🎯 **POINTS CLÉS DESIGN**

### **UX Principles**

- **Clarté** : Information essentielle visible immédiatement
- **Feedback** : Status et confirmations actions utilisateur
- **Efficacité** : Actions fréquentes accessibles rapidement
- **Cohérence** : Patterns identiques sur toutes les interfaces

### **Responsive Design**

- **Desktop** : Layout 3 colonnes avec sidebar
- **Tablet** : Layout 2 colonnes, sidebar collapsible
- **Mobile** : Layout 1 colonne, navigation bottom tabs

### **Accessibility**

- **Contraste** : WCAG AA compliant (4.5:1 minimum)
- **Navigation** : Keyboard accessible
- **Screen readers** : Semantic HTML + ARIA labels
- **Focus indicators** : Visible sur tous éléments interactifs

---

**Mockups Interface LifeCompanion**  
**Design System basé sur Tailwind CSS**  
**Responsive Mobile-First**
