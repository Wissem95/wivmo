# 📡 API DOCUMENTATION - LifeCompanion

## Laravel Backend REST API

---

## 🔗 **Base URL**

```
Production: https://api.lifecompanion.app/v1
Staging: https://staging-api.lifecompanion.app/v1
Local: http://localhost:8000/api/v1
```

## 🔐 **Authentication**

```yaml
Type: Laravel Sanctum (Bearer Token)
Header: Authorization: Bearer {token}
Expiration: 24 hours (renouvelable)
```

---

## 👤 **AUTHENTICATION ENDPOINTS**

### **POST /auth/register**

Inscription nouvel utilisateur

**Request Body:**

```json
{
  "name": "Wissem Boukhris",
  "email": "wissem@example.com",
  "password": "SecurePass123!",
  "password_confirmation": "SecurePass123!"
}
```

**Response 201:**

```json
{
  "success": true,
  "message": "User registered successfully",
  "data": {
    "user": {
      "id": 1,
      "name": "Wissem Boukhris",
      "email": "wissem@example.com",
      "email_verified_at": null,
      "created_at": "2024-01-15T10:30:00Z",
      "updated_at": "2024-01-15T10:30:00Z"
    },
    "token": "1|abc123def456ghi789jkl012mno345pqr678stu901vwx234yz567",
    "expires_at": "2024-01-16T10:30:00Z"
  }
}
```

### **POST /auth/login**

Connexion utilisateur existant

**Request Body:**

```json
{
  "email": "wissem@example.com",
  "password": "SecurePass123!"
}
```

**Response 200:**

```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "name": "Wissem Boukhris",
      "email": "wissem@example.com",
      "profile": {
        "timezone": "Europe/Paris",
        "language": "fr",
        "notifications_enabled": true
      }
    },
    "token": "2|def456ghi789jkl012mno345pqr678stu901vwx234yz567abc123",
    "expires_at": "2024-01-16T10:30:00Z"
  }
}
```

### **POST /auth/logout**

Déconnexion (révoque le token)

**Headers:** `Authorization: Bearer {token}`

**Response 200:**

```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## 📱 **DEVICE MANAGEMENT**

### **GET /devices**

Liste des appareils IoT de l'utilisateur

**Headers:** `Authorization: Bearer {token}`

**Query Parameters:**

- `status` (optional): `active`, `inactive`, `maintenance`
- `type` (optional): `sensor`, `actuator`
- `per_page` (optional): 10-100, default 15

**Response 200:**

```json
{
  "success": true,
  "data": {
    "devices": [
      {
        "id": "device_001",
        "name": "Capteur Salon Principal",
        "type": "multi_sensor",
        "status": "active",
        "location": {
          "room": "salon",
          "coordinates": { "x": 2.5, "y": 3.2 }
        },
        "sensors": [
          {
            "type": "temperature",
            "unit": "celsius",
            "last_reading": {
              "value": 23.5,
              "timestamp": "2024-01-15T10:28:00Z"
            }
          },
          {
            "type": "humidity",
            "unit": "percentage",
            "last_reading": {
              "value": 45.2,
              "timestamp": "2024-01-15T10:28:00Z"
            }
          }
        ],
        "battery_level": 87,
        "signal_strength": -45,
        "firmware_version": "1.2.3",
        "created_at": "2024-01-10T09:00:00Z",
        "updated_at": "2024-01-15T10:28:00Z"
      }
    ],
    "pagination": {
      "current_page": 1,
      "per_page": 15,
      "total": 5,
      "last_page": 1
    }
  }
}
```

### **POST /devices**

Ajouter un nouveau device

**Request Body:**

```json
{
  "device_id": "device_002",
  "name": "Capteur Chambre",
  "type": "multi_sensor",
  "location": {
    "room": "bedroom",
    "coordinates": { "x": 1.8, "y": 2.1 }
  },
  "configuration": {
    "sampling_rate": 60,
    "sensors_enabled": ["temperature", "humidity", "co2"]
  }
}
```

**Response 201:**

```json
{
  "success": true,
  "message": "Device added successfully",
  "data": {
    "device": {
      "id": "device_002",
      "name": "Capteur Chambre",
      "status": "pending_activation",
      "activation_code": "ABC123DEF456"
    }
  }
}
```

---

## 📊 **SENSOR DATA**

### **GET /devices/{deviceId}/readings**

Historique des lectures d'un appareil

**Headers:** `Authorization: Bearer {token}`

**Query Parameters:**

- `sensor_type` (optional): `temperature`, `humidity`, `co2`, `light`, `noise`
- `from` (optional): ISO 8601 datetime
- `to` (optional): ISO 8601 datetime
- `interval` (optional): `1m`, `5m`, `15m`, `1h`, `1d`
- `aggregation` (optional): `avg`, `min`, `max`, `count`

**Example:** `/devices/device_001/readings?sensor_type=temperature&from=2024-01-15T00:00:00Z&interval=1h&aggregation=avg`

**Response 200:**

```json
{
  "success": true,
  "data": {
    "device_id": "device_001",
    "sensor_type": "temperature",
    "interval": "1h",
    "aggregation": "avg",
    "readings": [
      {
        "timestamp": "2024-01-15T10:00:00Z",
        "value": 23.2,
        "unit": "celsius",
        "quality": "good"
      },
      {
        "timestamp": "2024-01-15T11:00:00Z",
        "value": 23.8,
        "unit": "celsius",
        "quality": "good"
      }
    ],
    "statistics": {
      "count": 24,
      "min": 21.5,
      "max": 25.1,
      "avg": 23.4,
      "std_dev": 0.8
    }
  }
}
```

### **POST /mqtt/readings**

Endpoint pour réception données MQTT (interne)

**Headers:** `X-MQTT-Token: {internal_token}`

**Request Body:**

```json
{
  "device_id": "device_001",
  "timestamp": "2024-01-15T10:30:15Z",
  "readings": [
    {
      "sensor_type": "temperature",
      "value": 23.5,
      "unit": "celsius"
    },
    {
      "sensor_type": "humidity",
      "value": 45.2,
      "unit": "percentage"
    }
  ],
  "metadata": {
    "battery_level": 87,
    "signal_strength": -45
  }
}
```

**Response 201:**

```json
{
  "success": true,
  "message": "Readings processed successfully",
  "data": {
    "processed_count": 2,
    "ml_classification_queued": true
  }
}
```

---

## 🤖 **ACTIVITY CLASSIFICATION**

### **GET /activities**

Historique des activités classifiées

**Headers:** `Authorization: Bearer {token}`

**Query Parameters:**

- `from`, `to`: Période de temps
- `confidence_min`: Seuil de confiance (0.0-1.0)
- `activity_type`: `work`, `rest`, `sleep`, `exercise`, `cooking`

**Response 200:**

```json
{
  "success": true,
  "data": {
    "activities": [
      {
        "id": 1234,
        "activity_type": "work",
        "confidence": 0.89,
        "start_time": "2024-01-15T09:00:00Z",
        "end_time": "2024-01-15T12:30:00Z",
        "duration_minutes": 210,
        "location": "salon",
        "environmental_context": {
          "avg_temperature": 23.1,
          "avg_humidity": 44.5,
          "light_level": "bright",
          "noise_level": "low"
        },
        "features_used": [
          "temperature_stability",
          "low_movement_pattern",
          "consistent_co2_increase",
          "time_of_day_context"
        ]
      }
    ]
  }
}
```

### **POST /activities/classify**

Déclencher classification manuelle

**Request Body:**

```json
{
  "device_id": "device_001",
  "time_window": {
    "from": "2024-01-15T14:00:00Z",
    "to": "2024-01-15T15:00:00Z"
  },
  "force_recompute": false
}
```

**Response 202:**

```json
{
  "success": true,
  "message": "Classification queued",
  "data": {
    "job_id": "classify_job_5678",
    "estimated_completion": "2024-01-15T15:02:00Z"
  }
}
```

---

## 📈 **ANALYTICS & INSIGHTS**

### **GET /analytics/dashboard**

Données pour dashboard principal

**Headers:** `Authorization: Bearer {token}`

**Query Parameters:**

- `period`: `today`, `week`, `month`, `custom`
- `from`, `to`: Si period=custom

**Response 200:**

```json
{
  "success": true,
  "data": {
    "summary": {
      "period": "today",
      "active_devices": 3,
      "total_readings": 1440,
      "activities_detected": 8,
      "avg_classification_confidence": 0.87
    },
    "environmental_metrics": {
      "temperature": {
        "current": 23.5,
        "avg_today": 23.2,
        "trend": "stable",
        "comfort_score": 8.5
      },
      "humidity": {
        "current": 45.2,
        "avg_today": 46.1,
        "trend": "decreasing",
        "comfort_score": 9.0
      },
      "air_quality": {
        "co2_ppm": 420,
        "status": "excellent",
        "trend": "stable"
      }
    },
    "activity_breakdown": {
      "work": { "duration_minutes": 480, "percentage": 60.0 },
      "rest": { "duration_minutes": 180, "percentage": 22.5 },
      "sleep": { "duration_minutes": 120, "percentage": 15.0 },
      "other": { "duration_minutes": 20, "percentage": 2.5 }
    },
    "recommendations": [
      {
        "type": "environment",
        "priority": "medium",
        "title": "Aération recommandée",
        "description": "Le taux de CO2 augmente progressivement depuis 2h",
        "action": "Ouvrir une fenêtre 10-15 minutes"
      }
    ]
  }
}
```

### **GET /analytics/trends**

Tendances et patterns

**Response 200:**

```json
{
  "success": true,
  "data": {
    "weekly_patterns": {
      "most_active_hours": ["09:00", "14:00", "20:00"],
      "sleep_pattern": {
        "avg_bedtime": "23:15",
        "avg_wake_time": "07:30",
        "sleep_quality_score": 7.8
      },
      "work_productivity": {
        "peak_hours": ["10:00-12:00", "14:00-16:00"],
        "focus_score": 8.2,
        "interruptions_per_day": 3.2
      }
    },
    "environmental_correlations": [
      {
        "correlation": "temperature_productivity",
        "strength": 0.73,
        "description": "Productivité optimale entre 21-24°C"
      }
    ]
  }
}
```

---

## 🔔 **NOTIFICATIONS**

### **GET /notifications**

Liste des notifications utilisateur

**Response 200:**

```json
{
  "success": true,
  "data": {
    "notifications": [
      {
        "id": 1001,
        "type": "environmental_alert",
        "title": "Température élevée détectée",
        "message": "La température du salon dépasse 26°C depuis 30 minutes",
        "priority": "medium",
        "is_read": false,
        "action_required": true,
        "actions": [
          { "type": "dismiss", "label": "Ignorer" },
          { "type": "ventilate", "label": "Programmer ventilation" }
        ],
        "created_at": "2024-01-15T15:30:00Z"
      }
    ]
  }
}
```

### **POST /notifications/{id}/mark-read**

Marquer notification comme lue

**Response 200:**

```json
{
  "success": true,
  "message": "Notification marked as read"
}
```

---

## ⚙️ **USER PREFERENCES**

### **GET /user/preferences**

Récupérer préférences utilisateur

**Response 200:**

```json
{
  "success": true,
  "data": {
    "preferences": {
      "comfort_ranges": {
        "temperature": { "min": 20, "max": 24, "unit": "celsius" },
        "humidity": { "min": 40, "max": 60, "unit": "percentage" }
      },
      "notifications": {
        "environmental_alerts": true,
        "activity_insights": true,
        "daily_summary": true,
        "quiet_hours": { "start": "22:00", "end": "08:00" }
      },
      "privacy": {
        "data_retention_days": 365,
        "share_anonymous_analytics": false
      }
    }
  }
}
```

### **PUT /user/preferences**

Mettre à jour préférences

**Request Body:**

```json
{
  "comfort_ranges": {
    "temperature": { "min": 21, "max": 25 }
  },
  "notifications": {
    "environmental_alerts": false
  }
}
```

---

## 🔧 **SYSTEM ENDPOINTS**

### **GET /health**

Health check API

**Response 200:**

```json
{
  "status": "healthy",
  "timestamp": "2024-01-15T15:45:00Z",
  "services": {
    "database": "up",
    "redis": "up",
    "mqtt_broker": "up",
    "ml_service": "up"
  },
  "metrics": {
    "response_time_ms": 45,
    "active_connections": 127,
    "queue_jobs_pending": 3
  }
}
```

### **GET /metrics**

Métriques Prometheus (auth admin)

**Response 200:**

```prometheus
# HELP api_requests_total Total API requests
# TYPE api_requests_total counter
api_requests_total{method="GET",endpoint="/devices",status="200"} 1542

# HELP sensor_readings_total Total sensor readings processed
# TYPE sensor_readings_total counter
sensor_readings_total{device_type="multi_sensor"} 45672

# HELP ml_classification_accuracy ML model accuracy
# TYPE ml_classification_accuracy gauge
ml_classification_accuracy 0.89
```

---

## 🚨 **ERROR RESPONSES**

### **Standard Error Format**

```json
{
  "success": false,
  "error": {
    "code": "VALIDATION_ERROR",
    "message": "The given data was invalid",
    "details": {
      "email": ["The email field is required"],
      "password": ["The password must be at least 8 characters"]
    }
  },
  "request_id": "req_abc123def456"
}
```

### **HTTP Status Codes**

- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `429` - Rate Limited
- `500` - Internal Server Error

---

## 📝 **RATE LIMITING**

```yaml
Authentication endpoints: 5 requests/minute
General API: 100 requests/minute
Data ingestion: 1000 requests/minute
Admin endpoints: 20 requests/minute
```

---

## 🔒 **SECURITY**

### **Headers Required**

```yaml
Content-Type: application/json
Accept: application/json
Authorization: Bearer {token}
X-Requested-With: XMLHttpRequest
```

### **CORS Policy**

```yaml
Allowed Origins:
  - https://app.lifecompanion.com
  - https://dashboard.lifecompanion.com
  - http://localhost:3000 (dev only)

Allowed Methods: GET, POST, PUT, DELETE, OPTIONS
Allowed Headers: Authorization, Content-Type, Accept
```

---

**API Documentation v1.0**  
**Last Updated: 25 juin 2025**  
**Base URL: https://api.lifecompanion.app/v1**
