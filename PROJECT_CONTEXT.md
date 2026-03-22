cat << 'EOF' > PROJECT_CONTEXT.md
# PROJECT CONTEXT — AI Growth OS

## 🎯 Vision
Build an AI-powered growth operating system for SMBs (starting with agri businesses)

---

## 🧩 Core Modules
- Lead Generation Engine
- Campaign Automation Engine
- Creative Intelligence Engine
- Analytics Engine

---

## 🏗️ Architecture
Frontend → FastAPI → PostgreSQL → Redis → Celery → n8n → AI APIs

---

## ⚙️ Current Tech Stack
- FastAPI (Backend)
- PostgreSQL (DB)
- Redis (Queue)
- Celery (Workers)
- n8n (Automation)
- Docker (Infra)

---

## 📊 Database Entities
- users
- clients
- campaigns
- leads
- analytics

---

## 🔄 Data Flow
Client → API → DB → Queue → Worker → AI → Campaign → Leads → Analytics

---

## 🚀 Current Phase

Phase G2 — Backend Verification

---

## ✅ Completed

* Governance setup (structure, GitHub, PROJECT_CONTEXT.md)
* Infrastructure setup (Docker containers running)
* PostgreSQL, Redis, n8n, Grafana active
* Redis verified (PONG)

---

## 🔄 In Progress

* Backend audit (checking existing code)

---

## ⏭️ Next Steps

* Verify backend structure
* Decide rebuild vs reuse
* Start clean backend inside /backend
* Connect FastAPI to PostgreSQL and Redis

---

## ⚠️ Known Issues

* FastAPI not running
* Backend not verified yet

---

## 🧠 Notes
- Always follow modular architecture
- Never skip data flow validation
EOF
