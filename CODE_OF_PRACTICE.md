# 🧭 Code of Practice — Dracula

This document describes how contributors and maintainers work together on **Dracula**.  
It focuses entirely on engineering quality, communication efficiency, and mutual respect.

---

## 1. Purpose

To maintain a clean, stable, and high-quality open-source codebase where:
- Contributions are judged by **technical merit**.
- Feedback is **objective and data-driven**.
- Collaboration stays focused on **building great software**.

---

## 2. Communication

- Keep discussion **technical and relevant**.  
- Stay concise and professional — avoid unrelated topics.  
- If you disagree, back it up with code, benchmarks, or references.  
- Report bugs with clear reproduction steps.  
- Respect people’s time — read existing issues before opening new ones.

---

## 3. Pull Requests

- Each PR should solve **one problem** or add **one feature**.  
- Link to related issue(s) or user story IDs.  
- Write meaningful commit messages (e.g., `fix: resolve crash on CSV export`).  
- Request a review only when tests pass and the code compiles cleanly.  
- Small, frequent changes > large, sweeping rewrites.

---

## 4. Issue Guidelines

When creating an issue:
1. Use a clear title that describes the problem.  
2. Include your platform, Flutter version, and steps to reproduce.  
3. Attach logs or screenshots when useful.  
4. Avoid “me too” comments — add reproducible data instead.

---

## 5. Code Review Principles

- Focus on **code, not coder**.  
- Prefer readability and maintainability over cleverness.  
- Suggest improvements with examples, not opinions.  
- Approve when the change meets functional and performance goals.

---

## 6. Testing and Quality

- Run `flutter analyze` and all tests before pushing.  
- New features should include at least one test or manual QA note.  
- No warnings, print statements, or commented-out code in PRs.  
- Keep build size and performance in mind — test on real devices.

---

## 7. Project Direction

- Major features and architecture decisions are discussed in **Roadmap.md**.  
- Maintainers decide based on usability, maintainability, and performance impact.  
- Anyone can propose ideas — well-written proposals are prioritized.

---

## 8. Licensing

All contributions are under the **AGPL-3.0 license**.  
Use SPDX headers (`// SPDX-License-Identifier: AGPL-3.0-only`) in new files.

---

## 9. Professional Conduct

- Treat all contributors as peers.  
- No harassment, spam, or off-topic debates.  
- Keep communication technical and problem-solving oriented.  
- Violations result in review limits or removal from the project.

---

## 10. Maintainers

- Current Maintainer: [@baileyburnsed](https://github.com/Burnsedia)  
- Maintainers may refactor, revert, or reject code if it risks stability or performance.  
- Merges require a clean build and at least one review.

---

### In short:
> Build great software.  
> Keep it professional.  
> Stay focused on results.
