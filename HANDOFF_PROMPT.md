We are continuing AI Growth OS project.

CURRENT STATE:

* Governance layer completed (GitHub, structure, PROJECT_CONTEXT.md)
* Infrastructure running via Docker (PostgreSQL, Redis, n8n, Grafana, Prometheus)
* Redis verified (PONG)
* FastAPI not running
* Backend existence unclear (currently auditing)

OBJECTIVE:

* Verify existing backend (reuse vs rebuild decision)
* Then build production-grade FastAPI backend inside /backend
* Connect to PostgreSQL and Redis

INSTRUCTIONS:
Act as system architect.
Do NOT skip steps.
First audit backend structure, then decide rebuild or upgrade.

Guide step-by-step with:

* folder validation
* structure decision
* clean implementation if needed
