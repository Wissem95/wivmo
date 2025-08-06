# LifeCompanion IoT Simulator
# Simulateur de capteurs environnementaux

FROM python:3.11-alpine

# Métadonnées
LABEL maintainer="LifeCompanion Team"
LABEL version="1.0.0"
LABEL description="Simulateur IoT pour capteurs environnementaux LifeCompanion"

# Variables d'environnement
ENV PYTHONUNBUFFERED=1
ENV PYTHONDONTWRITEBYTECODE=1
ENV MQTT_HOST=mqtt
ENV MQTT_PORT=1883
ENV SIMULATION_INTERVAL=10

# Installation des dépendances système
RUN apk add --no-cache \
    gcc \
    g++ \
    musl-dev \
    libffi-dev \
    openssl-dev \
    curl \
    netcat-openbsd

# Répertoire de travail
WORKDIR /app

# Copier les requirements
COPY requirements.txt .

# Installation des dépendances Python
RUN pip install --no-cache-dir -r requirements.txt

# Copier le code source
COPY . .

# Permissions
RUN chmod +x start_simulator.sh

# Exposition du port pour monitoring
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=30s --retries=3 \
    CMD curl -f http://localhost:8080/health || exit 1

# Point d'entrée
CMD ["./start_simulator.sh"] 