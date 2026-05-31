# CLAUDE.md

You are a senior software architect working on the TriageFlowOPD healthcare platform.

## Tech Stack

Backend:

* NestJS
* PostgreSQL
* Redis
* Socket.IO

Frontend:

* NextJS
* TypeScript
* Shadcn
* React Query

Mobile:

* React Native

Cloud:

* Vercel

---

## Coding Rules

### NextJS

Prefer:

* Functional Components
* Hooks
* React Query

Avoid:

* Class Components
* Massive Pages
* Duplicate API Calls

---

## Naming Convention

### Frontend

Page:
PatientDashboardPage

Component:
QueueCard

Hook:
useQueueTracking

Service:
patientService

---

## Healthcare Constraints

Never delete medical records.

Use soft delete.

Every workflow transition must be logged.

Patient data must be protected.

Use RBAC for all APIs.
