# 🩸 Dracula — User Stories (Mobile: Android & iOS)

> **Version:** v1.0 (MVP Roadmap Ready)  
> **Purpose:** Define all core and extended functionality for Dracula’s Android & iOS releases.  
> **Format:** As a `<role>` I want `<goal>` so that `<benefit>`  
> **Acceptance:** Given / When / Then statements  
> **Priority Levels:**  
> - 🟥 P0 — MVP 1 (Offline Core)  
> - 🟧 P1 — MVP 2 (Insights & QoL)  
> - 🟨 P2 — MVP 3 (Cloud & Advanced)

---

## 🩸 Epic 1 — Offline Data Tracking (🟥 P0)

### US-1.1 — Create Blood Sugar Entry
**As** a user  
**I want** to log my blood sugar reading  
**So that** I can monitor my levels over time  

**Acceptance Criteria**
- Given the app is open  
  When I tap “Add Entry” and input value, timestamp (defaults to now), and category  
  Then the entry saves locally in SQLite and displays a success message  
- Units: mg/dL (default) or mmol/L  
- Works entirely offline  

---

### US-1.2 — Edit/Delete Entry
**As** a user  
**I want** to edit or delete an entry  
**So that** I can correct mistakes  

**Acceptance Criteria**
- Long-press an entry to reveal Edit/Delete options  
- Confirm delete before removal  
- Updates reflected immediately in the local database  

---

### US-1.3 — View History
**As** a user  
**I want** to view a list of past entries  
**So that** I can review my readings  

**Acceptance Criteria**
- Chronological list grouped by day  
- Filter by date range or category  
- Pull-to-refresh reloads from SQLite  

---

### US-1.4 — Units & Timezone
**As** a user  
**I want** correct units and local time handling  
**So that** my readings remain regionally accurate  

**Acceptance Criteria**
- User can select units in Settings  
- All timestamps use device timezone  

---

### Non-Functional Requirements
- Cold start under 2 seconds  
- Fully offline operation  
- No telemetry or background network calls  

---

## 🧩 Epic 2 — Custom Categories (🟥 P0)

### US-2.1 — Add Category
**As** a user  
**I want** to add custom metrics  
**So that** I can track more than blood sugar  

**Acceptance Criteria**
- “Add Category” button with Name + optional Unit  
- New category appears in entry form immediately  

---

### US-2.2 — Manage Categories
**As** a user  
**I want** to rename or delete categories  
**So that** I can organize my data  

**Acceptance Criteria**
- Rename updates labels across the app  
- Delete prompts:  
  - “Delete only category” (reassign entries to Uncategorized)  
  - “Delete category and entries” (permanent removal)  

---

## 📤 Epic 3 — Export & Backup (🟥 P0)

### US-3.1 — Export CSV
**As** a user  
**I want** to export data to CSV  
**So that** I can analyze it externally  

**Acceptance Criteria**
- Choose range: All / 7 days / 30 days / Custom  
- Select destination via native file picker  
- Confirmation message after successful export  

---

### US-3.2 — Export TXT
**As** a user  
**I want** to export plain text  
**So that** I can review or print my readings  

**Acceptance Criteria**
- Readable text format grouped by date and category  
- Same destination flow as CSV  

---

### US-3.3 — Database Backup
**As** a user  
**I want** to back up the SQLite DB file  
**So that** I have a full local copy  

**Acceptance Criteria**
- Exports `.db` file to user-chosen location  
- Import flow planned for later release  

---

## 🎨 Epic 4 — UI/UX & Themes (🟥 P0)

### US-4.1 — Dracula Theme
**As** a user  
**I want** a dark Dracula theme  
**So that** the interface is easy on my eyes  

**Acceptance Criteria**
- Global Material 3 theme using Dracula palette  
- Text contrast meets WCAG AA standard  

---

### US-4.2 — Home Dashboard
**As** a user  
**I want** a simple home screen with quick access  
**So that** I can add readings quickly  

**Acceptance Criteria**
- Floating Action Button adds new entry  
- Today’s entries and average displayed prominently  

---

### US-4.3 — Onboarding
**As** a new user  
**I want** a short onboarding  
**So that** I understand how the app works  

**Acceptance Criteria**
- 3–4 slides: privacy, units, categories, export tips  
- Skippable anytime  

---

### Accessibility & Performance
- Screen reader labels for all controls  
- Large touch targets (≥44px)  
- Smooth animations on 60 fps devices  

---

## 🔔 Epic 5 — Reminders & Notifications (🟧 P1)

### US-5.1 — Schedule Reminder
**As** a user  
**I want** to set daily or weekly reminders  
**So that** I never forget to log my readings  

**Acceptance Criteria**
- Choose time & repeat schedule  
- Local notification triggers offline  

---

### US-5.2 — Missed Log Nudge
**As** a user  
**I want** gentle alerts after inactivity  
**So that** I stay consistent  

**Acceptance Criteria**
- Detect >8 hr gap since last entry  
- One notification per gap window  

---

## 📈 Epic 6 — Charts & Insights (🟧 P1)

### US-6.1 — Trend Chart
**As** a user  
**I want** to visualize trends  
**So that** I can see patterns over time  

**Acceptance Criteria**
- Line chart by day/week/month  
- Tap points for detailed view  

---

### US-6.2 — Summary Stats
**As** a user  
**I want** averages and ranges  
**So that** I can assess control  

**Acceptance Criteria**
- Compute average, min, max locally  
- Update dynamically with new data  

---

## ☁️ Epic 7 — Sync & Cloud (🟧 P1 → 🟨 P2)

### US-7.1 — Manual Cloud Sync
**As** a user  
**I want** to push/pull backups to my own cloud  
**So that** I keep full control  

**Acceptance Criteria**
- Choose provider: Nextcloud, Dropbox, iCloud  
- Manual “Sync Now” button  
- Timestamp of last sync shown  

---

### US-7.2 — Conflict Resolution
**As** a user  
**I want** clear choices on data conflicts  
**So that** I avoid accidental loss  

**Acceptance Criteria**
- If remote newer → prompt to merge or keep local  
- Auto-backup before overwrite  

---

### US-7.3 — Dracula Cloud (Encrypted)
**As** a user  
**I want** optional E2E-encrypted sync  
**So that** I can back up securely  

**Acceptance Criteria**
- Local encryption with user-held key  
- Cloud never stores readable data  

---

## 🔒 Epic 8 — Privacy & Security (🟥 P0 → 🟧 P1)

### US-8.1 — No Account / No Telemetry
**As** a privacy-conscious user  
**I want** no sign-in or tracking  
**So that** my data stays local  

**Acceptance Criteria**
- No analytics SDKs  
- No external calls except explicit exports  

---

### US-8.2 — App Lock
**As** a user  
**I want** biometric or PIN protection  
**So that** my data is safe on my device  

**Acceptance Criteria**
- Enable/disable via Settings  
- Support Face ID / Touch ID / Android Biometrics  

---

## 🌍 Epic 9 — Internationalization (🟨 P2)

### US-9.1 — i18n Ready
**As** a global user  
**I want** translations  
**So that** I can use the app in my language  

**Acceptance Criteria**
- All strings routed through localization  
- Baseline: English; community-driven translations  

---

## 📥 Epic 10 — Import / Migration (🟨 P2)

### US-10.1 — Import CSV
**As** a user  
**I want** to import existing data  
**So that** I can migrate from another tracker  

**Acceptance Criteria**
- Field mapping before import  
- Preview 10 rows  
- Validate timestamps & units  

---

## ✅ MVP Checklists

### MVP 1 — Offline Core
- [ ] US-1.1 Create Entry  
- [ ] US-1.2 Edit/Delete Entry  
- [ ] US-1.3 View History  
- [ ] US-1.4 Units & Timezone  
- [ ] US-2.1 Add Category  
- [ ] US-2.2 Manage Categories  
- [ ] US-3.1 Export CSV  
- [ ] US-3.2 Export TXT  
- [ ] US-3.3 DB Backup  
- [ ] US-4.1 Dracula Theme  
- [ ] US-4.2 Home Dashboard  
- [ ] US-4.3 Onboarding  
- [ ] US-8.1 Privacy  

### MVP 2 — Insights & Sync
- [ ] US-5.1 Schedule Reminder  
- [ ] US-5.2 Missed Log Nudge  
- [ ] US-6.1 Trend Chart  
- [ ] US-6.2 Stats Summary  
- [ ] US-7.1 Manual Cloud Sync  
- [ ] US-7.2 Conflict Handling  
- [ ] US-8.2 App Lock  

### MVP 3 — Cloud & Advanced
- [ ] US-7.3 Dracula Cloud  
- [ ] US-9.1 i18n  
- [ ] US-10.1 Import CSV  

---

## 🧪 Acceptance Testing Guidelines
- Validate all MVP1 flows offline  
- Verify CSV/TXT exports open in Excel, Numbers, Sheets  
- Accessibility audit (TalkBack, VoiceOver)  
- Load test: ≥50 k entries keep scrolling/search <150 ms  
- Confirm no background network traffic  

---

_Authored by [@baileyburnsed](https://github.com/Burnsedia)_  
_Last updated: November 2025_

