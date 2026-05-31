---

description: Frontend Development Rules
globs:

* "frontend/**"
  alwaysApply: true

---

# Frontend Rules

## Stack

* NextJS
* TypeScript
* Shadcn
* React Query
* Zustand

---


## Component Rules

Prefer:

* Functional Components
* Hooks
* Reusable Components

Avoid:

* Class Components
* Large Components >300 lines

---

## Page Structure

Each page:

* UI
* Hooks
* Service Calls

Business logic belongs inside:

* hooks
* services

---

## Data Fetching

Use React Query.

Never call axios directly inside components.

Use:

repository/

Example:

patientService.ts

queueService.ts

paymentService.ts

---

## State Management

Use Zustand for:

* Auth
* User Profile
* Notification
* Global Settings

Use React Query for:

* API Data
* Server Cache

---

## Performance

Use:

* React.memo
* Lazy Loading
* Code Splitting

Avoid unnecessary re-renders.
