# ROADMAP.md

> **Current Milestone**: MVP Core
> **Goal**: Establish the base functionality to connect patients and doctors with queue tracking, AI help, and booking.

## Must-Haves
- [ ] Working architecture, state management, and shared resources
- [ ] Safe and secure authentication for patients and doctors
- [ ] Core integration with the Node.js SwiftCare backend

## Phases

### Phase 1: Core Architecture & Shared Resources
**Status**: ✅ Complete
**Objective**: Establish the base architecture for the Flutter app. Set up state management, routing, and shared resources.

### Phase 2: Authentication & User Profiles
**Status**: ✅ Complete
**Objective**: Implement user login and registration flows. Setup authentication tokens and session management. Develop the user profile section.

### Phase 3: SwiftCare API Integration
**Status**: ✅ Complete
**Objective**: Connect the application to the SwiftCare backend API. Implement data models and network clients. Verify communication and handle errors/loading states.

### Phase 4: Full Backend Synchronization & API Hardening
**Status**: ✅ Complete
**Objective**: Align all Flutter models, services, and API interactions with the `BACKEND_MAP.md` and `FRONTEND_API_PLAYBOOK.md` contracts. Implement missing endpoints, fix data shape mismatches, ensure strict role-based access, and standardize error handling.

### Phase 5: Codebase Refactor & Perfection
**Status**: ✅ Complete
**Objective**: Systematically audit and improve every file in the `lib` folder. Introduce type-safe models, unify service behaviors, and optimize data flows without changing the UI or breaking features.
