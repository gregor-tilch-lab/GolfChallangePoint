#!/usr/bin/env bash
set -euo pipefail

# Challangepoint GitHub templates + gh-CLI helper installer (single-file)
#
# What this does:
# - Creates GitHub issue templates:
#   - .github/ISSUE_TEMPLATE/epic_challangepoint_mvp.md
#   - .github/ISSUE_TEMPLATE/user_story.md
# - Creates a GitHub CLI helper script:
#   - scripts/gh_create_mvp_issues.sh
# - Creates a short scripts/README.md
#
# Usage:
#   1) Download this file into the ROOT of your GitHub repo
#   2) Run:
#        bash setup_challangepoint_github_templates.sh
#
# Notes:
# - This does NOT require zip files.
# - If you do not want the gh-CLI helper script, you can delete /scripts afterwards.

mkdir -p .github/ISSUE_TEMPLATE
mkdir -p scripts

cat > .github/ISSUE_TEMPLATE/epic_challangepoint_mvp.md <<'EOF'
---
name: "EPIC: Challangepoint MVP"
about: "Create the MVP epic issue for Challangepoint (Web + API)"
title: "EPIC: Challangepoint MVP (Web + API) — Calendar + Drag&Drop Task Library + Player Logging (English UI)"
labels: [epic, mvp]
assignees: []
---

# EPIC: Challangepoint MVP (Web + API)
**Goal:** Deliver a working MVP for academy training organization with:
- Coach/Academy planning (multi-player oversight)
- Drag & Drop task templates into a player calendar (FullCalendar External DnD)
- Player execution + logging (numeric/text)
- RBAC (Admin/Coach/Player)
- UI language: **English** (recommended locale: en-GB)

---

## 1) Product Objective (MVP)
Challangepoint MVP is the operational core for a golf academy:
- **Players** see what to do today/this week, and log results/feedback.
- **Coaches/Academy** can assign structured tasks/blocks by dragging templates into the calendar.

**MVP success criteria:**
- A coach can schedule tasks for a player via drag & drop in under 15 seconds per task.
- A player can log results in under 30 seconds per task.
- A coach can review player logs per session/event in one place.

---

## 2) Roles & Permissions
### Roles
- **ADMIN**: user management, templates, imports
- **COACH**: manage assigned players, calendar planning, review logs
- **PLAYER**: view own calendar/todos, submit logs, create personal tasks (optional)

### Access Rules (MVP)
- Players can only access their own events and logs.
- Coaches can only access assigned players (via CoachPlayerLink).
- Admin can access everything.

---

## 3) Core MVP Workflows
### Workflow A — Coach planning
1) Coach selects a player
2) Coach opens player calendar (week/month)
3) Coach drags a task template from the library into the calendar slot
4) System creates a calendar event linked to that template
5) Coach can move/resize the event and it persists

### Workflow B — Player execution & logging
1) Player opens Today/Week view
2) Player opens a scheduled task
3) Player submits a log based on template input type:
   - `numeric_success`: attempts + successes
   - `numeric_score`: score numeric
   - `text_reflection`: reflection text
4) Player marks task done (optional) / log serves as completion evidence

### Workflow C — Coach review
1) Coach opens an event in the calendar
2) Coach sees submitted logs for that event (history)
3) Coach can add a private note (optional MVP)

---

## 4) Domain Rules (Important)
### Task Categories (SG mapping)
Task templates must have exactly ONE category:
- `APPROACH`
- `OTT` (Off the Tee)
- `ARG` (Around the Green)
- `PUTTING`

**SG TOTAL is NOT allowed** as a task category (dashboard-only later).

### Task Template Input Schemas
- `numeric_success`  (attempts + successes)
- `numeric_score`    (score numeric)
- `text_reflection`  (free text)

### UI Language
- All UI strings, navigation, buttons: **English**
- Suggested default locale: **en-GB** (Monday week start + optional 24h)

---

## 5) Technical Decisions (Locked)
- Monorepo: pnpm workspaces + turborepo
- `apps/web`: Next.js (TypeScript)
- `apps/api`: NestJS (TypeScript) + Prisma
- DB: Postgres (docker-compose for local)
- Calendar: **FullCalendar** + `@fullcalendar/interaction` for External Drag & Drop

### FullCalendar persistence rules
- External drop uses `eventReceive`
- Persist on drop: `eventReceive → POST /calendar/events`
- Persist move/resize: `eventDrop/eventResize → PATCH /calendar/events/:id`
- On API error: revert UI change

---

## 6) Out of Scope (Phase 2+)
Not part of MVP (can be roadmap):
- Gamification (coins, leaderboards)
- Automatic difficulty engine (30% → 80% → harder)
- Video library & tagging
- Tournament periodization background coloring
- Advanced comparisons (peer group vs PGA), spider charts
- Real-time chat (MVP can be optional later)

---

## 7) Definition of Done (DoD) for this Epic
- [ ] Repo scaffolding complete (web+api+shared) and `pnpm dev` runs both apps
- [ ] DB schema migrated, seed users exist (Admin/Coach/Player)
- [ ] Auth works (JWT + RBAC)
- [ ] Coach can:
  - [ ] view assigned players
  - [ ] open player calendar
  - [ ] drag task templates into calendar (persisted)
  - [ ] move/resize events (persisted)
  - [ ] view player logs for an event
- [ ] Player can:
  - [ ] view Today/Week tasks
  - [ ] open a task and submit a log (numeric/text)
- [ ] CI passes on PR (lint + build)
- [ ] `.env.example` exists and no secrets are committed
- [ ] Basic Swagger docs available in API (`/docs`)

---

## 8) Milestones / Sprint Plan (Sub-Issues)
> Create the issues below and replace #TBD with actual issue numbers.

### Sprint 0 — Setup & Foundation
- [ ] S0-01 Monorepo scaffold (pnpm + turborepo) (#TBD)
- [ ] S0-02 Postgres docker-compose (#TBD)
- [ ] S0-03 Prisma schema MVP v1 (#TBD)
- [ ] S0-04 Auth + RBAC (NestJS) (#TBD)
- [ ] S0-05 CI workflow (GitHub Actions) (#TBD)

### Sprint 1 — Core API + Basic Calendar UI
- [ ] S1-01 API: TaskTemplates CRUD (#TBD)
- [ ] S1-02 API: Calendar Events CRUD (#TBD)
- [ ] S1-03 Web: Coach players list/grid (#TBD)
- [ ] S1-04 Web: FullCalendar base (load/display events) (#TBD)

### Sprint 2 — Drag & Drop + Player Logging
- [ ] S2-01 Web: Task library accordion + External Draggable (#TBD)
- [ ] S2-02 Web: Persist on drop (eventReceive → POST) (#TBD)
- [ ] S2-03 Web: Persist move/resize (PATCH) (#TBD)
- [ ] S2-04 Web: Player Today/Week UI (#TBD)
- [ ] S2-05 Web/API: Player task logging (numeric/text) (#TBD)

### Sprint 3 — Custom Templates + Optional Upgame Import (minimal)
- [ ] S3-01 Custom task templates (“Individual Blocks”) (#TBD)
- [ ] S3-02 Coach event drawer shows logs (#TBD)
- [ ] S3-03 Admin: Upgame CSV import → snapshots (optional) (#TBD)

---

## 9) QA Notes / Test Checklist
### Coach drag & drop test
- Drag template into calendar → event persists after refresh
- Move event → persists after refresh
- Resize event → persists after refresh
- Forbidden access: coach cannot create events for non-assigned players

### Player logging test
- Player logs numeric_success: attempts/successes saved correctly
- Player logs text_reflection: text saved correctly
- Coach can view logs per event
EOF

cat > .github/ISSUE_TEMPLATE/user_story.md <<'EOF'
---
name: "User Story"
about: "Create a user story with acceptance criteria"
title: "US-XXX: <short title>"
labels: [user-story]
assignees: []
---

## User Story
As a **<role>**, I want **<capability>** so that **<benefit>**.

## Context / Notes
- UI language must be **English**
- Relevant module: <calendar/tasks/logging/auth>

## Acceptance Criteria
- [ ] ...
- [ ] ...

## API / Data (if relevant)
- Endpoint(s):
- Entity changes:

## UI (if relevant)
- Screen(s):
- UX notes:
EOF

cat > scripts/gh_create_mvp_issues.sh <<'EOF'
#!/usr/bin/env bash
set -euo pipefail

# Creates the EPIC + Sprint issues via GitHub CLI (gh).
#
# Usage:
#   bash scripts/gh_create_mvp_issues.sh OWNER/REPO
#
# Requirements:
#   - Install GitHub CLI: https://cli.github.com/
#   - Authenticate: gh auth login
#   - You must have permission to create issues in the repo

REPO="${1:-}"
if [[ -z "$REPO" ]]; then
  echo "Usage: $0 OWNER/REPO"
  exit 1
fi

echo "Creating labels (safe to re-run)..."
create_label () {
  local name="$1"
  local color="$2"
  local desc="$3"
  gh label create "$name" --repo "$REPO" --color "$color" --description "$desc" 2>/dev/null || true
}

create_label "epic" "5319e7" "Epic tracking issue"
create_label "mvp" "0e8a16" "Minimum viable product"
create_label "user-story" "fbca04" "User story"
create_label "infra" "1d76db" "Infrastructure"
create_label "db" "006b75" "Database"
create_label "auth" "d4c5f9" "Authentication/Authorization"
create_label "api" "0052cc" "Backend/API"
create_label "web" "c2e0c6" "Frontend/Web"
create_label "calendar" "fef2c0" "Calendar"
create_label "drag-drop" "bfdadc" "Drag & drop"
create_label "tasks" "f9d0c4" "Tasks/Templates"
create_label "player" "c5def5" "Player experience"
create_label "coach" "b60205" "Coach experience"
create_label "logging" "d93f0b" "Logging/Tracking"
create_label "import" "0b1f3a" "Import/Integration"
create_label "ci" "000000" "CI/CD"

echo "Preparing EPIC body from template (removing YAML front matter)..."
EPIC_BODY="$(awk 'BEGIN{fm=0} /^---$/ {fm++; next} fm>=2 {print}' .github/ISSUE_TEMPLATE/epic_challangepoint_mvp.md)"

create_issue () {
  local title="$1"
  local body="$2"
  local labels="$3"
  gh issue create --repo "$REPO" --title "$title" --body "$body" --label "$labels"
}

echo "Creating EPIC + Sprint issues..."
create_issue "EPIC: Challangepoint MVP (Web + API) — Calendar + Drag&Drop + Player Logging (English UI)" "$EPIC_BODY" "epic,mvp"

create_issue "S0-01 Monorepo scaffold (pnpm + turborepo)" "Create monorepo with apps/web (Next.js) + apps/api (NestJS) + packages/shared. Ensure pnpm dev runs both." "mvp,infra"
create_issue "S0-02 Postgres docker-compose" "Add infra/docker-compose.yml with Postgres. API connects via DATABASE_URL." "db,infra"
create_issue "S0-03 Prisma schema MVP v1" "Implement Prisma schema: User, PlayerProfile, CoachPlayerLink, TaskTemplate, CalendarEvent, TaskLog." "db,mvp"
create_issue "S0-04 Auth + RBAC (NestJS)" "JWT auth (access+refresh) + role guard ADMIN/COACH/PLAYER. /me endpoint." "auth,api"
create_issue "S0-05 CI workflow (GitHub Actions)" "Add CI: install pnpm, lint and build web+api." "ci"

create_issue "S1-01 API: TaskTemplates CRUD" "CRUD endpoints for TaskTemplates. Validate category (APPROACH/OTT/ARG/PUTTING) and input_schema." "api,tasks"
create_issue "S1-02 API: Calendar Events CRUD" "CRUD endpoints for CalendarEvents. Coaches can only create for assigned players." "api,calendar"
create_issue "S1-03 Web: Coach players list/grid" "Coach page to list assigned players; link to player calendar." "web,coach"
create_issue "S1-04 Web: FullCalendar base (load/display events)" "FullCalendar Week/Month views for player calendar; load events from API; event click opens drawer." "web,calendar"

create_issue "S2-01 Web: Task library + External Draggable" "Accordion + search task templates; make items draggable (FullCalendar Draggable)." "web,drag-drop,tasks"
create_issue "S2-02 Persist on drop (eventReceive -> POST)" "On eventReceive, POST /calendar/events; set returned id; on error revert." "web,api,drag-drop"
create_issue "S2-03 Persist move/resize (PATCH)" "On eventDrop/eventResize, PATCH /calendar/events/:id; on error revert." "web,calendar"
create_issue "S2-04 Web: Player Today/Week UI" "Player home showing Today/This Week tasks (mobile-friendly)." "web,player"
create_issue "S2-05 Player task logging (numeric/text)" "Player opens event and submits TaskLog based on input schema; coach can view logs later." "web,api,logging"

create_issue "S3-01 Custom task templates (Individual Blocks)" "Coach can create personal templates; appear in library; CRUD." "web,tasks"
create_issue "S3-02 Coach event drawer shows logs" "Coach sees TaskLogs in event drawer." "web,coach"
create_issue "S3-03 Admin: Upgame CSV import (optional)" "CSV upload endpoint creating snapshots (SG Approach/OTT/ARG/Putting/Total)." "api,import"

echo "Done. Open your repo Issues to see created items."
EOF

cat > scripts/README.md <<'EOF'
# GitHub Automation (optional)

This folder contains an optional helper script to create the EPIC + Sprint issues using GitHub CLI.

## Requirements
- Install GitHub CLI: https://cli.github.com/
- Authenticate: `gh auth login`
- Permission to create issues in the target repo

## Usage
From the repo root:
```bash
bash scripts/gh_create_mvp_issues.sh OWNER/REPO
```

The script will create:
- 1 EPIC issue
- Sprint issues S0–S3

You can then assign milestones, add to GitHub Projects, and refine acceptance criteria.
EOF

chmod +x scripts/gh_create_mvp_issues.sh

echo "[OK] Installed GitHub issue templates + gh-CLI helper script."
echo "Files created:"
echo " - .github/ISSUE_TEMPLATE/epic_challangepoint_mvp.md"
echo " - .github/ISSUE_TEMPLATE/user_story.md"
echo " - scripts/gh_create_mvp_issues.sh"
echo " - scripts/README.md"
