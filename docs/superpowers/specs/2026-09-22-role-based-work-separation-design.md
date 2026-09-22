# Role-Based Work Separation — Design

Date: 2026-09-22
Status: Approved in chat, pending spec review

## Goal

Separate what each role can see and do in EduVerse360:

- **Teacher**: sees only their own assignments and online classes; can create, update, and delete them; sees the lists.
- **Student**: sees assignments and online classes read-only (list + detail, including assignment PDFs). No create/update/delete anywhere.
- **School admin / super admin**: authorized everywhere and see everything — every screen, button, tab, and route is available to them with no role gating applied. They see all teachers' assignments and online classes (unfiltered) and can manage them (full CRUD), plus the existing school-classes, students, teachers tabs.

## Context (current state)

- Roles live in `UserRole` (`Features/Authentication/Models/UserModel.swift`): `superAdmin`, `student`, `teacher`, `schoolAdmin`.
- `AppTab.tabs(for:)` (`App/AppTab.swift`) already differs per role:
  - teacher: `[.home, .work, .classes, .settings]`
  - student: `[.home, .classes, .settings]`
  - admins: `[.home, .work, .students, .classes, .teachers, .settings]`
- `AppTab.rootView(role:)`: `.work` → `AllTeacherAssignmentView()` for teacher, `TeacherOnlyView()` placeholder otherwise; `.classes` → `ListOnlineClassView()` for teacher, `AllClassesView()` otherwise.
- `TeacherAssignmentByIdView` already gates Update/Delete on `session.activeRole != .student`.
- `AllTeacherAssignmentView` and `ListOnlineClassView` currently show their create buttons (`+`) to every role, and neither filters by teacher.
- `Assignment` and `OnlineClass` models both include `teacherId: Int`. `UserSession.user` (`UserModel`) includes `id: Int`, so client-side filtering by the logged-in teacher's id is possible.

## Approach

Role-gate the existing shared views (no duplicate student-only screens). Views read `UserSession.activeRole` from the environment — the same pattern `TeacherAssignmentByIdView` already uses. Navigation is gated at the button level (a student has no create/update/delete buttons, so they can't reach those routes); real authorization must also be enforced by the backend, which is out of scope for this change.

**Gating rule:** the only role that is ever restricted is `.student`. Every gate is written as `session.activeRole == .student` (hide) or `!= .student` (show), so `.teacher`, `.schoolAdmin`, and `.superAdmin` always pass. Admins are additionally never filtered — they always see the full, unfiltered lists.

## Design

### 1. Tabs (`App/AppTab.swift`)

- `tabs(for:)`:
  - student: `[.home, .work, .classes, .settings]`
  - teacher: `[.home, .work, .classes, .settings]` (unchanged)
  - admins: `[.home, .work, .students, .classes, .teachers, .settings]` (unchanged — the admin Work tab now covers online classes too, so no extra tab is needed)
- `rootView(role:)`:
  - `.work`: teacher → `AllTeacherAssignmentView()` (own items); student → same view read-only; admins → `AdminWorkView()` (see below). `TeacherOnlyView` is removed.
  - `.classes`: teacher/student → `ListOnlineClassView()` (teacher filtered, student read-only); admins → `AllClassesView()` (unchanged).
- Delete `Features/Teacher/View/TeacherOnlyView.swift` and its references.

### 1a. Admin Work tab — `AdminWorkView` (new)

Admins see **all teacher work in one tab**: every teacher's assignments and every teacher's online classes, unfiltered.

- New view `AdminWorkView` (in `Features/Authentication/View/` next to `HomeView`, or under `Features/Assignment/` — decide at implementation; it combines two features, so `App/` is also acceptable).
- A segmented `Picker` at the top switches between two segments: **Assignments** and **Online Classes**.
- The segments embed the existing `AllTeacherAssignmentView()` and `ListOnlineClassView()` unfiltered (both already hide nothing from admin roles), so admins keep full create/update/delete on both.
- Navigation works as today: each embedded view pushes its detail routes onto the tab's `NavigationPath` via `TabRouter`.

### 2. Assignment list — `AllTeacherAssignmentView`

- Inject `@Environment(UserSession.self)`.
- Hide the `+` button when `session.activeRole == .student`.
- Pass `session.user?.id` to the ViewModel fetch when the role is `.teacher`; pass `nil` for student/admin (no filter).
- Title stays "My assignments" for teacher; for student/admin use "Assignments".

### 3. Assignment ViewModel — `AllTeacherAssignmentViewModel`

- `func allTeacherAssignment(teacherId: Int? = nil) async` — after decoding, keep only items where `teacherId == assignment.teacherId` when non-nil, then apply the status filter as today. Counts (`totalCount`, `publishedCount`, `pendingCount`, `recentAssignments`) already derive from the filtered `assignments` array, so they stay correct.

### 4. Online class list — `ListOnlineClassView`

- Inject `@Environment(UserSession.self)`.
- Hide the floating `+` button when `session.activeRole == .student`.
- Teacher: filter the fetched list to `onlineClass.teacherId == session.user?.id` (ViewModel gains the same optional `teacherId` parameter). Student/admin: no filter.

### 5. Detail screens

- `TeacherAssignmentByIdView`: existing `!= .student` gating kept as-is.
- `OnlineClassByIdView`: verify its update/delete actions are hidden for students; add the same `session.activeRole != .student` gate if missing (expected missing — to confirm at implementation time).

### 6. Create/Update screens

No changes. They remain reachable only via the gated buttons/routes.

## Data flow

`UserSession` is already injected app-wide (`EduVerse360App.swift`), so views only add an `@Environment` read. No storage or API changes: the same `api/assignments` and `api/online-classes` list endpoints are used; filtering is client-side.

## Error handling

Unchanged: ViewModels set `errorMessage` from `error.localizedDescription`. A teacher with zero own items sees the existing empty state; the assignments list currently has no explicit empty state — acceptable for this change.

## Known limitation

The logged-in `UserModel` carries no class/section info, so students see **all** assignments and online classes read-only, not only their own class's. Scoping a student's list to their class/section needs backend support (a student-specific endpoint or richer `/users/me`) and is a follow-up, not part of this change.

## Testing

No test targets exist in the repo (see AGENTS.md). Verification:

1. `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build` passes.
2. Manual pass against the local backend (`http://localhost:3000`), logging in once per role:
   - teacher: sees only own assignments/online classes; create/update/delete work.
   - student: sees both lists and details (incl. PDF); no `+`, Update, or Delete anywhere.
   - school admin and super admin: Work tab shows all teachers' assignments and online classes via the segmented control, full manage on both — no button or tab is ever hidden from admin roles.

## Out of scope

- Backend authorization enforcement (client gating is UX-level only).
- Student class/section-scoped lists (needs backend support).
- Keychain token storage, tests, CI.
