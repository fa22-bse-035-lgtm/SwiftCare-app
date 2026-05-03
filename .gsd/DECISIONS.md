## Phase 4 Decisions (Book Appointment Refactor)

**Date:** 2026-04-05

### Scope
- **Window**: The booking window is extended to **30 days**.
- **Dynamic Dates**: Dates are filtered based on `Doctor.availableDays` (e.g., "Monday", "Friday") before fetching shifts.

### Approach
- **Optimization (Option A+)**: Parallel pre-fetching using `Future.wait` for all valid dates identified in the 30-day window.
- **Reason**: Balances a wider choice for patients with minimal initial loading time and high "snappiness" during date selection.
- **Single Source of Truth**: Backend provides the `shiftId` and the exact time-slot strings. All local time-generation logic in the app will be removed.

### Constraints
- **Zero-Warning**: All changes must avoid `withOpacity` and other linting issues.
- **Model Parity**: The `appointment` map passed to `PatientDetails` must match the backend contract precisely.
