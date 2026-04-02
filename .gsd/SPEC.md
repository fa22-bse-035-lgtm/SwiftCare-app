# SPEC.md — Project Specification

> **Status**: `FINALIZED`

## Vision
SwiftCare is a Flutter-based mobile application. It aims to connect Clients/Patients with Doctors efficiently, offering live queue tracking, AI assistance, and seamless appointment booking, powered by a Node.js/MongoDB backend.

## Goals
1. Establish a robust modular architecture in Flutter based on well-defined architectural constraints.
2. Integrate seamlessly with the Node.js/MongoDB backend via REST/WebSockets.
3. Implement core functional features: Live queue tracking, AI chatbot assistant, and Appointment booking.

## Non-Goals (Out of Scope)
- Web platform (initially targeted at Android/iOS mobile devices).

## Users
- **Clients/Patients**: Users who seek medical services. They can book appointments, use the AI assistant, and track their position in the queue.
- **Doctors**: Users who provide medical services. They can track their schedule and view the number of patients in their current shift.

## Platform Features
1. **Live Queue Tracking**: Implemented via WebSockets (`socket.io`). Clients/patients stay informed of their position in the queue. Doctors can see the total number of patients waiting for their shift.
2. **AI Chatbot Assistant**: Allows users to ask multiple platform-related queries.
3. **Appointment Booking Service**: Helps clients/patients book consultation appointments with doctors online without hassle.

## Constraints
- **Backend Stack**: Node.js with MongoDB.
- **State/Communication**: Relies on socket interactions for real-time queues.

## Architectural Constraints
1. **Helper Functions**: Any frontend-only logic (formatting, validation, non-backend logic) must reside in `lib/services/helper_function.dart`.
2. **Component Reusability**: Any widget used in more than one screen must be refactored into a standalone file in `lib/widgets/` then imported and used where needed.
3. **API Layering**: All backend requests must be in `lib/services/api_service.dart`, except for Auth logic which remains in `lib/services/auth_service.dart`.
4. **State Management (Single Source of Truth)**: Use `lib/services/shared_resource.dart` as the primary data store. All UI components must fetch data from here. Any local changes must update this file first before being synced to the backend.

## Engineering Principles
1. **Stateless Default**: Always prioritize making screens `StatelessWidget`.
2. **Logic Separation**: If state is absolutely required, strictly separate the UI from the logic (Business Logic/Functions) into separate files or clear architectural layers.
3. **Lean Widgets**: No 'fat' widgets—keep `build` methods lean and modular.
4. **Backend Sync**: Whenever working on any backend-related task or API integration, strictly consult `BACKEND_MAP.md` and `FRONTEND_API_PLAYBOOK.md` to understand the backend architecture and ensure full synchronization.

## Success Criteria
- [ ] Flutter app securely authenticates both patient and doctor roles.
- [ ] Patients can successfully book appointments which save to the Node.js backend.
- [ ] Live queue accurately syncs state between the server and all connected clients and doctors.
- [ ] AI Chatbot reliably answers user queries.
