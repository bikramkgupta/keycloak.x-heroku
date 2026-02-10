# keycloak.x-heroku — Migration Context

## Tech Stack
- **Language**: Java (Quarkus-based)
- **Framework**: Keycloak.X (Identity and Access Management)
- **Package Manager**: Docker (containerized deployment)
- **Runtime Version**: Keycloak.X 15.0.2 on Quarkus

## Architecture
This is a containerized Keycloak.X deployment for Identity and Access Management. It's based on the official Keycloak Docker image with modifications for Heroku deployment. The application provides OAuth, SAML, and identity management services. It uses Quarkus for faster startup times and lower memory usage compared to the WildFly-based version.

Key components:
- Keycloak server with PostgreSQL database backend
- Custom entrypoint script for Heroku-specific configuration
- Edge proxy mode enabled for Heroku routing

## Modules & Key Files
- `Dockerfile` — Container definition based on quay.io/keycloak/keycloak-x:15.0.2
- `docker-entrypoint.sh` — Custom startup script that parses DATABASE_URL and configures Keycloak
- `app.json` — Heroku app configuration with PostgreSQL addon
- `heroku.yml` — Container stack configuration for Heroku
- `README.md` — Deployment instructions and references

## Packages
| Package | Old Version | New Version | Notes |
|---|---|---|---|
| keycloak | 15.0.2 | 26.5.2 | Major upgrade - changed paths, commands, env vars |

## Heroku -> DO Mapping
| Heroku Feature | DO Equivalent | Status |
|---|---|---|
| Container stack | Docker deployment | ✓ Ready |
| DATABASE_URL parsing | PostgreSQL connection | Needs modification |
| PORT variable | App Platform PORT | ✓ Compatible |
| Edge proxy mode | Load balancer | ✓ Compatible |
| heroku-postgresql:hobby-dev | DO Managed PostgreSQL | Needs setup |

## Environment Variables
### Required
| Variable | Purpose | .env.docker Value | .env.remote Value |
|---|---|---|---|
| KEYCLOAK_ADMIN | Admin username | admin | admin |
| KEYCLOAK_ADMIN_PASSWORD | Admin password | change_me_local | ${KEYCLOAK_ADMIN_PASSWORD} |
| DATABASE_URL | PostgreSQL connection | postgresql://localhost:5432/keycloak_test | ${DATABASE_URL} |
| PORT | HTTP port | 8080 | ${PORT} |

## Test Endpoints
| Endpoint | Method | Expected Status | Expected Response | Notes |
|---|---|---|---|---|
| / | GET | 200 | Keycloak welcome page | Main landing page |
| /auth | GET | 200/302 | Keycloak admin console | Admin interface |
| /auth/realms/master | GET | 200 | JSON realm config | Master realm info |
| /health | GET | 200 | Health check | If available |

## Expected Warnings
- Database migration warnings during first startup
- Configuration optimization suggestions
- Quarkus startup information messages
- SSL/TLS warnings in development mode

## Local Testing
- **Docker build**: PASS
- **Container port**: 8080
- **Test results**: Root endpoint returns 302 (redirect), container starts successfully
- **Startup time**: ~6 seconds
- **Admin user**: Auto-created with username 'admin'

## Remote Deployment
- **App ID**: TBD (Phase B fills this)
- **App URL**: TBD (Phase B fills this)
- **Region**: syd1

## Env Files
- `.env.docker` — Local Docker testing variables
- `.env.remote` — Deployment variables (pushed to GitHub Secrets)

## Observations
- This is a well-structured containerized application using Keycloak.X 15.0.2
- The Dockerfile is simple but uses an older Keycloak version
- The entrypoint script handles DATABASE_URL parsing well but assumes postgres:// prefix
- App uses edge proxy mode which is suitable for load balancers
- No custom application code - this is a deployment wrapper for Keycloak
- The container already listens on $PORT variable, making it App Platform compatible