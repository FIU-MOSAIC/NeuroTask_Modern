# NeuroTask_Modern

A redesign of a research-oriented mobile application using modern tools, security practices, and maintainable dependencies.

## Overview

**NeuroTask_Modern** is a reimagined version of the original [NeuroTask_Running](https://github.com/FIU-MOSAIC/NeuroTask_Running) application. The legacy application has become difficult to maintain and insecure due to outdated dependencies and deprecated APIs. This project aims to provide a modern, secure, and extensible foundation for continued development and contributions.

## Why This Redesign

The original NeuroTask_Running project had several limitations that warranted a complete overhaul:

- Relied on **outdated Java (8–11)** dependencies.
- Contained **hardcoded API keys**, posing serious security risks.
- Used **deprecated or discontinued Flutter libraries**, making long-term support and updates infeasible.

Rather than patching over a fragile codebase, the team opted to start fresh. **NeuroTask_Modern** is designed as a forward-compatible solution, offering a cleaner development experience and serving as a maintainable reference for future contributors and researchers.

## Getting Started

Our project is a Flutter project using firebase as a backend for storing data on users. Boot up your IDE (preferably VS code) and begin setting up the Flutter dev environment (heres a link on installing Flutter for VS code: https://docs.flutter.dev/tools/vs-code.) 

After you have a flutter dev environment set up properly with an Android or iOS emulator, clone the project and run ``flutter doctor`` to first identify everything is working properly and then ``flutter pub get`` to download all the necessary dependencies of the project. From there, you can being working on the project.

### Dependencies
Our main dependencies are GetX, firebase auth, firebase core, and cloud firestore. GetX is a tool that helps with managing/maintaining stateful widgets and routing for our project. The remaining firebase packages enable us to have the project communicate with the firebase database, manage the secure login/user-authentication, and store data from each user into the firebase database.

### Routing
We built routing to be simple for developers to work with and to avoid tedious additions to our main menu. GetX enables us to have a two-step implementation for any new games implemented into the application:
1. **First Add new page to getPages**
   - In the ``main.dart`` file we utilize GetX's getMaterialApp to automatically manage accessing and loading pages access the getPages array where we will add any new page to the list.
2. **Update the game registry**
   - The ``game_registry.dart`` file is essentially a list of all the games implemented or not with all the important information needed for any other part of the project to access and utilize (like the main menu.)
   - The registry includes important information like game title, icon, route, description, and a IsImplemented bool for the developers.
   - Simply add the game with the necessary information and the game will work (assuming its implemented.) The main menu is an example of how this registry can be used to access all the games implemented without worry of future additions of new games.

## Developer Instructions

This project follows a lightweight but disciplined development workflow to ensure code quality and maintainability, even in the absence of enforced repository rules.

> Note: Since this is a **private repository under the GitHub Free plan**, we are unable to enforce branch protection rules (e.g., mandatory pull requests, required reviewers, etc.). However, all developers are expected to follow the guidelines below.

### Development Workflow

1. **Create a New Branch**
   - Use meaningful branch names that describe the feature or fix you're working on.
   - Example: `feature/onboarding-flow`, `bugfix/api-timeout`, `refactor/state-management`

2. **Open a Pull Request**
   - Once your work is complete, open a pull request targeting the `main` branch.
   - Write a clear description of what was done and why.
     - Example:

```
# Description:

Closes #<ISSUE_NUMBER>

<DESCRIPTION>

# Changes

- Added ...
- Deleted ...
- Refactored ...
- Updated ...
```

3. **Code Review Required**
   - Before merging to `main`, **request a review from at least one other developer**.
   - Incorporate feedback and resolve comments before merging.

4. **Merging Guidelines**
   - Only merge into `main` after approval and successful checks (if applicable).
   - Prefer **squash and merge** to maintain a clean commit history.

5. **Creating Issues**
   - Creating issues should follow a design similar to pull request formats.
   - Example:

```
# Description:

<DESCRIPTION>

# Requirements:

- <POSSIBLE UNIT TESTS>
- <FUNCTIONALITY DESIRED>
- <etc.>
```

### Development Best Practices

- Write self-explanatory commits and pull request descriptions.
- Keep pull requests focused and small when possible.
- Document any changes that affect usage, security, or architecture.
- Treat this project as production-grade: aim for clean, secure, and tested code.

---

By following this workflow, we ensure that the codebase remains reliable, maintainable, and collaborative for current and future contributors.

## Current Progress

Ongoing tasks, project scope, and team roles are tracked via this collaborative Google Doc:

[Current Development Document](https://docs.google.com/document/d/1Fi6wgocjx7yoMKxidWixmnUD7SkGD_GJSXwH_-rNlRM/edit?usp=sharing)

This document includes:

- Active development progress
- User story tracking
- Technical priorities
- Roadmap overview

## Known Issues and Goals
#### Firebase plugin incompatibility

Firebase plugins depend on specific Android NDK version, but the project is configured to an older version.

> **Error output:**

```
Your project is configured with Android NDK 26.3.11579264, but the following plugin(s) depend on a different Android NDK version:
cloud_firestore requires Android NDK 27.0.12077973
firebase_auth requires Android NDK 27.0.12077973
firebase_core requires Android NDK 27.0.12077973
Fix this issue by using the highest Android NDK version (they are backward compatible).
Add the following to /Users/carlos/Projects/NeuroTask_Modern/android/app/build.gradle.kts:

    android {
        ndkVersion = "27.0.12077973"
        ...
    }
```
