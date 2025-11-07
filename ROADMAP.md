# 🩸 Dracula – Roadmap

> **Mission:** A privacy-first blood sugar and health tracker for Android & iOS.  
> 100% offline, open source, and owned by the user.

---

## 🚀 Vision

Dracula helps users track their blood sugar, carbs, exercise, and other metrics **without vendor lock-in** or **data collection**.  
Built with **Flutter**, powered by **SQLite**, and themed with **Dracula colors**, it runs entirely offline and can optionally sync with user-controlled cloud storage or Dracula Cloud (E2E encrypted).

---

## 🧭 Release Phases

### 🩸 MVP 1 — Offline Core (Q1)

> Focus: fully offline experience, basic tracking, customization, and export.

#### ✅ Core Features
- [ ] **Offline data tracking**
  - Create, view, edit, delete blood sugar entries
  - Store locally in SQLite
- [ ] **Custom categories**
  - Add, rename, and delete custom metrics (Carbs, Exercise, etc.)
- [ ] **Local export**
  - Export CSV / TXT files
  - Export full SQLite DB as backup
- [ ] **Dracula theme**
  - Dark-mode Material 3 interface using Dracula palette
- [ ] **Basic onboarding**
  - Unit selection (mg/dL, mmol/L)
  - Quick intro to privacy & export
- [ ] **No telemetry / account**
  - App functions 100% offline with zero tracking

#### 📱 Platforms
- [x] Android (primary build)
- [ ] iOS (initial test build)

#### 🧪 QA Targets
- App cold start < 2s
- Local DB handles 50k entries smoothly
- CSV export verified on common spreadsheet apps

---

### ⚙️ MVP 2 — Insights & Quality of Life (Q2)

> Focus: usability, reminders, and visualization.

#### 🔔 New Features
- [ ] **Reminders & notifications**
  - Schedule daily/weekly reminders for glucose checks
  - Missed logging nudges (configurable)
- [ ] **Charts & stats**
  - Line graph for trends (fl_chart)
  - Daily/weekly/monthly averages, min/max
- [ ] **Manual cloud sync**
  - Push/pull exports to local or user-chosen cloud (Nextcloud, Dropbox, iCloud Drive)
- [ ] **App lock**
  - Optional biometric / PIN protection
- [ ] **UI polish**
  - Dashboard cards for today’s readings
  - Smooth transitions & haptics

#### 🧩 Non-Functional Goals
- Accessibility: TalkBack/VoiceOver tested
- Translations support (English baseline)
- Test on Android 13–15, iOS 17+

---

### ☁️ MVP 3 — Dracula Cloud & Ecosystem (Q3–Q4)

> Focus: encrypted sync, integrations, and community growth.

#### 🔐 Core Additions
- [ ] **Dracula Cloud (E2E encrypted)**
  - User key never leaves device
  - Multi-device sync (Android + iOS)
- [ ] **Import / migration**
  - CSV import with mapping preview
  - Restore from local `.db` backup
- [ ] **Analytics dashboard**
  - Combine multiple metrics (blood sugar vs carbs)
- [ ] **Health integrations**
  - Apple HealthKit, Google Fit read/write
- [ ] **Cross-platform parity**
  - Desktop companion (Linux, macOS, Windows)

#### 🌍 Community
- [ ] GitHub Discussions & Templates
- [ ] Flutter Showcase listing
- [ ] Beta testers for Dracula Cloud
- [ ] Localization drive (community translations)

---

## 🧱 Technical Stack

| Layer | Tech |
|-------|------|
| Framework | Flutter |
| Database | SQLite (`sqflite` or `drift`) |
| State Mgmt | Riverpod / Bloc |
| Charts | `fl_chart` |
| Notifications | `flutter_local_notifications` |
| Cloud Sync | WebDAV, Dropbox SDK (optional), Dracula Cloud (custom) |
| UI | Material 3 + Dracula Theme |

---

## 🧩 Milestone Overview

| Milestone | Focus | Target | Status |
|------------|--------|--------|---------|
| **MVP 1 – Offline Core** | Tracking, export, theme | Q1 | 🟠 In Progress |
| **MVP 2 – Insights** | Charts, reminders, manual sync | Q2 | ⏳ Planned |
| **MVP 3 – Cloud** | Encrypted sync, integrations | Q3–Q4 | ⏳ Planned |

---

## 📅 Future Ideas (Community / Stretch)

- [ ] Apple Watch / WearOS companion app  
- [ ] Widgets (today’s average, quick add)  
- [ ] Open API for importing readings (CLI, REST)  
- [ ] Encrypted web dashboard  
- [ ] “Dracula Pro” premium build (charts + sync subscription)

---

## 🧑‍💻 Contributing

- Check [`USER_STORIES.md`](./USER_STORIES.md) for detailed acceptance criteria  
- See [`CONTRIBUTING.md`](./CONTRIBUTING.md) before submitting PRs  
- Discuss ideas in [GitHub Discussions](../../discussions)

---

## 🪪 License

Licensed under **AGPL-3.0**.  
Dracula is free and open-source software — forks and local builds are encouraged.  
Hosted or distributed derivatives must remain open source.

---

_Authored by [@baileyburnsed](https://github.com/Burnsedia)_  
_Open-source for diabetics, biohackers, and privacy enthusiasts alike._
