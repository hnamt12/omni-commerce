# OmniCommerce AI Entrypoint

READ THIS FILE FIRST.

---

# PROJECT

Tech stack:
- Laravel 12
- Vue 3
- InertiaJS
- TailwindCSS

Architecture:
- Service Pattern
- Thin Controllers
- Composition API

---

# IMPORTANT RULES

NEVER:
- scan the whole repository
- inspect vendor
- inspect node_modules
- inspect storage/logs
- inspect public/build

ONLY READ:
- files directly related to current task
- current open file
- imported dependencies
- explicitly attached files

---

# PRIORITY FILE ORDER

When solving tasks:

1. Current file
2. Related composables/services
3. Related controller
4. Related route
5. Shared types/interfaces

STOP AFTER THESE.

DO NOT CONTINUE RECURSIVE SEARCHING.

---

# SOURCE OF TRUTH

Architecture:
@SYSTEM_ARCHITECTURE.md

Rules:
@PROJECT_RULES.md

Business Logic & Features:
@docs/modules/ (Contains specific flow and architecture for each module)

Skills:
@.antigravity/skills/
---

# TASK MEMORY

After completing tasks:
- update CHANGELOG.md
- update relevant blueprint
- save reusable patterns into docs/patterns/

---

# TOKEN OPTIMIZATION

Prefer:
- minimal context
- direct file reading
- no recursive scans

Maximum files per task:
- 3 to 8 files