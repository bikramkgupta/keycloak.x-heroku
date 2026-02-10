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
| KC_BOOTSTRAP_ADMIN_USERNAME | Admin username | admin | admin |
| KC_BOOTSTRAP_ADMIN_PASSWORD | Admin password | change_me_local | ${KC_BOOTSTRAP_ADMIN_PASSWORD} |
| DATABASE_URL | PostgreSQL connection | (optional - uses H2) | ${DATABASE_URL} |
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
- **App ID**: bd6db0f9-ac8a-42ad-989b-98d9c3ba62cc
- **App URL**: Not available (deployment blocked)
- **Region**: syd1
- **Status**: BLOCKED - Container exits with non-zero code
- **Database**: PostgreSQL cluster configured, app firewall rule added
- **GitHub Secrets**: All secrets (DO token, admin creds, DB URL) pushed successfully
- **GitHub Actions**: Deployment workflow created
- **Last Deployment**: b59b17fe-00cc-434f-9fc1-2f03a3fa27c5 (failed)
- **Issue**: Keycloak 26.5.2 container startup incompatible with custom entrypoint script

## Env Files
- `.env.docker` — Local Docker testing variables
- `.env.remote` — Deployment variables (pushed to GitHub Secrets)

## Observations
- Successfully upgraded from Keycloak.X 15.0.2 to Keycloak 26.5.2
- Major structural changes required: paths, commands, environment variables
- Updated entrypoint script for new command syntax (start vs config)
- Added support for both postgres:// and postgresql:// URL schemes
- Fixed proxy configuration from --proxy=edge to --proxy-headers=forwarded
- Added --http-enabled and --hostname-strict=false for proper startup
- Container tested successfully - starts in ~6 seconds and responds to HTTP
- App Platform deployment spec created with required environment variables
- No custom application code - this is a deployment wrapper for Keycloak
- Ready for Phase B deployment to DigitalOcean App Platform
## Shared Infrastructure

Region: syd1

### PostgreSQL Cluster
- Cluster ID: b32bfe92-51c0-4660-9879-92a7db886482
- Host: heroku-migration-pg-do-user-8198484-0.m.db.ondigitalocean.com
- Port: 25060
- Admin User: doadmin
- Admin Password: [REDACTED]
- Create app DB: `doctl databases db create b32bfe92-51c0-4660-9879-92a7db886482 <appname>_db`
- Create app user: `doctl databases user create b32bfe92-51c0-4660-9879-92a7db886482 <appname>_user`
- Connection string pattern: `postgresql://<user>:<password>@heroku-migration-pg-do-user-8198484-0.m.db.ondigitalocean.com:25060/<db>?sslmode=require`

