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
Phase G0 — Governance Setup

---

## ✅ Completed
- [ ] Global folder structure
- [ ] GitHub initialized
- [ ] PROJECT_CONTEXT.md created

---

## 🔄 In Progress
- Governance setup

---

## ⏭️ Next Steps
- System audit
- Backend alignment
- Redis + workers

---

## ⚠️ Known Issues
- Not audited yet

---

## 🧠 Notes
- Always follow modular architecture
- Never skip data flow validation
EOF
