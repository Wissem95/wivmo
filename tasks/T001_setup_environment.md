# 🛠️ T001 - Setup Environnement de Développement

**Sprint**: 1 | **Points**: 5 | **Assigné**: Wissem | **Priorité**: CRITICAL

---

## 🎯 **Objectif**

Configurer l'environnement de développement complet pour LifeCompanion avec Docker, Git, et tous les outils nécessaires.

## 📋 **Acceptance Criteria**

- [ ] Docker Compose fonctionnel avec tous les services
- [ ] Repository Git configuré avec branches
- [ ] Variables d'environnement configurées
- [ ] Base de données PostgreSQL + TimescaleDB opérationnelle
- [ ] Redis fonctionnel
- [ ] Tests de connectivité réussis

---

## 🔧 **Prompts à Utiliser**

### **1. Documentation Laravel via MCP**

```bash
# Prompt MCP pour Laravel 11
Je développe une application IoT avec Laravel 11.
J'ai besoin des meilleures pratiques pour :
- Configuration Docker pour Laravel 11
- Setup PostgreSQL avec Laravel
- Configuration Redis pour cache et queues
- Structure de projet recommandée pour une API IoT
- Configuration des variables d'environnement sécurisées

Fournis-moi un guide step-by-step avec exemples de code.
```

### **2. Documentation PostgreSQL + TimescaleDB via MCP**

```bash
# Prompt MCP pour Base de données
Je configure une base de données pour une application IoT qui collecte :
- Données de capteurs environnementaux (température, humidité, pression)
- Classifications d'activités avec timestamps
- Données utilisateurs et dispositifs

J'ai besoin de :
- Configuration PostgreSQL optimisée pour time-series
- Installation et configuration TimescaleDB
- Schema de base pour time-series data
- Index optimisés pour requêtes temporelles
- Configuration Docker pour PostgreSQL + TimescaleDB

Fournis des exemples concrets avec migrations Laravel.
```

### **3. Documentation Docker via MCP**

```bash
# Prompt MCP pour Docker
Je crée un environnement Docker pour une stack Laravel + Flutter + IoT.
Services nécessaires :
- Laravel 11 (PHP 8.2)
- PostgreSQL 13 + TimescaleDB
- Redis 6
- MQTT Broker (Mosquitto)
- Adminer (interface DB)

J'ai besoin de :
- docker-compose.yml optimisé pour développement
- Dockerfiles pour chaque service
- Configuration réseau entre services
- Volumes persistants
- Variables d'environnement sécurisées
- Scripts de démarrage

Fournis une configuration complète prête à utiliser.
```

---

## 📝 **Actions Détaillées**

### **Étape 1 : Utiliser MCP pour la Documentation**

<function_calls>
<invoke name="mcp_context7_resolve-library-id">
<parameter name="libraryName">Laravel
</invoke>
</function_calls>
