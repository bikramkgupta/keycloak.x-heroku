# Deployment Blockers - keycloak.x-heroku

## Issue: Container Exits with Non-Zero Code on App Platform

**Status**: Blocked after 4+ deployment attempts
**App ID**: bd6db0f9-ac8a-42ad-989b-98d9c3ba62cc
**Last Deployment ID**: b59b17fe-00cc-434f-9fc1-2f03a3fa27c5

### Problem
App Platform deployments consistently fail with "DeployContainerExitNonZero" error. The container builds successfully but exits during the wait phase after deployment.

### Attempted Solutions
1. **Database connectivity**: Added firewall rule for app to access PostgreSQL cluster
2. **Database parameters**: Updated entrypoint script to use correct Keycloak 26.5.2 parameter format (`--db-url-host` instead of `-Dkc.db.url.host`)
3. **Environment variables**: Added default PORT value (`${PORT:-8080}`) to handle missing PORT env var
4. **Simplified config**: Removed DATABASE_URL entirely to test basic Keycloak startup - still failed

### Technical Details
- **Keycloak Version**: Upgraded from 15.0.2 to 26.5.2
- **Base Image**: `quay.io/keycloak/keycloak:26.5.2`
- **Build Phase**: ✓ Passes (Docker build successful)
- **Deploy Phase**: ✗ Fails (container exits after deployment)
- **Logs**: Cannot retrieve runtime logs from failed deployments

### Root Cause Hypothesis
The custom entrypoint script may be incompatible with Keycloak 26.5.2:
- Major version upgrade changed command structure
- Parameter names and formats changed significantly
- Startup process may require different initialization steps

### Next Steps Required
1. Test locally with identical environment to App Platform
2. Review Keycloak 26.5.2 documentation for breaking changes
3. Potentially simplify to use standard Keycloak startup without custom entrypoint
4. Consider reverting to a stable Keycloak version (21.x or 22.x) that worked in Phase A testing

### Impact
- Phase B deployment blocked
- Cannot verify Keycloak functionality on App Platform
- Database and secrets are configured correctly but unused