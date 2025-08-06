-- LifeCompanion Database Initialization
-- Configuration PostgreSQL + TimescaleDB pour IoT

-- Créer l'extension TimescaleDB si elle n'existe pas
CREATE EXTENSION IF NOT EXISTS timescaledb;

-- Créer l'extension UUID si elle n'existe pas
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Créer l'extension PgCrypto pour le hashage
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Configuration PostgreSQL optimisée pour time-series
SET shared_preload_libraries = 'timescaledb';

-- Paramètres optimisés pour IoT et time-series
ALTER SYSTEM SET max_connections = 200;
ALTER SYSTEM SET shared_buffers = '256MB';
ALTER SYSTEM SET effective_cache_size = '1GB';
ALTER SYSTEM SET maintenance_work_mem = '64MB';
ALTER SYSTEM SET checkpoint_completion_target = 0.9;
ALTER SYSTEM SET wal_buffers = '16MB';
ALTER SYSTEM SET default_statistics_target = 100;
ALTER SYSTEM SET random_page_cost = 1.1;
ALTER SYSTEM SET effective_io_concurrency = 200;

-- Recharger la configuration
SELECT pg_reload_conf();

-- Créer la base de données si elle n'existe pas
SELECT 'CREATE DATABASE lifecompanion' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'lifecompanion');

-- Messages informatifs
SELECT 'PostgreSQL + TimescaleDB configuré avec succès pour LifeCompanion' as status;
SELECT 'Extensions disponibles : timescaledb, uuid-ossp, pgcrypto' as extensions; 