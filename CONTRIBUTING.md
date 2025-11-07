# 🩸 Contributing to Dracula

Thank you for taking the time to improve **Dracula**.  
This project is open source so anyone can help make it better — code, documentation, testing, or design.  
We care about **quality, privacy, and good engineering**. Nothing more, nothing less.

---

## 🧰 Requirements

- **Flutter 3.24+**  
- **Dart 3.3+**  
- A working Android or iOS device for testing  
- Basic Git knowledge

To get started:

```bash
flutter pub get
flutter run
```

---

## 💡 Ways to Contribute

- Fix bugs or crashes  
- Implement user stories from [`USER_STORIES.md`](./USER_STORIES.md)  
- Improve performance or battery usage  
- Add or improve documentation  
- Test and report reproducible issues  

If you’re not sure where to start, check the **“good first issue”** label on GitHub.

---

## 🧱 Workflow

1. **Fork** the repository.  
2. **Create a new branch:**

   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Write clear, maintainable code.**  
   Keep commits focused — one logical change per PR.  
4. **Run checks before pushing:**

   ```bash
   flutter analyze
   flutter test
   ```
5. **Use conventional commit messages:**

   ```
   feat: add CSV export
   fix: crash when saving entries
   docs: update README
   refactor: simplify DB service
   ```
6. **Push and open a Pull Request.**  
   - Describe *what* the change does and *why* it’s needed.  
   - Add screenshots for UI changes when relevant.  
   - Link any related issue numbers.

---

## 🧠 Code Style

- Follow Flutter’s built-in lints (`flutter analyze`).  
- Keep widgets small, clear, and composable.  
- Prefer explicit naming over clever shortcuts.  
- No unnecessary dependencies.  
- Avoid commented-out or dead code in PRs.

---

## 🧪 Testing Checklist

Before submitting a PR:

- [ ] App builds and runs on Android  
- [ ] App builds and runs on iOS  
- [ ] No warnings from `flutter analyze`  
- [ ] Tests pass (`flutter test`)  
- [ ] Offline features verified (add/edit/delete/export)  

---

## 📘 Documentation

If you add a new feature:

- Update `README.md` or `ROADMAP.md`.  
- Add usage examples where useful.  
- Keep explanations clear and technical.  

---

## 🔒 Licensing

All contributions are under the project’s existing license: **AGPL-3.0-only**.  
Include SPDX headers in new files:

```dart
// SPDX-License-Identifier: AGPL-3.0-only
```

By submitting a pull request, you agree your work can be distributed under this license.

---

## 🧩 Conduct and Communication

- Keep all communication technical and on-topic.  
- Focus on the code, not the coder.  
- Use data, benchmarks, and examples when giving feedback.  
- Avoid personal debates or unrelated discussions.  

This is a collaborative engineering project — not a social network.

---

## 🧭 Maintainers

- **Project Lead:** [@baileyburnsed](https://github.com/Burnsedia)  
- Maintainers review PRs for correctness, performance, and maintainability.  
- PRs may be refactored, delayed, or rejected if they don’t align with the project roadmap.

---

### In short

> Write clean code.  
> Explain your changes.  
> Test before you push.  
> Stay focused on making Dracula better.
