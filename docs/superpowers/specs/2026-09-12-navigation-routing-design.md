# Navigation & Routing Redesign — Design Spec

**Date:** 2026-09-12
**Status:** Approved (pending implementation plan)
**Scope:** App-wide navigation architecture for EduVerse360 (iOS, SwiftUI, Swift 5, iOS 17.6+)

## Problem

The current navigation system (App/AppRouter.swift + EduVerse360App.swift) has four intertwined problems:

1. **Two parallel navigation mechanisms.** Pushes go through `NavigationRouter.path`, while pre-login screens (login/register/OTP/forgot/reset) go through a separate `authScreen: AuthScreen` property. `AuthScreen.mainTab` duplicates what `session.isLoggedIn` already decides.
2. **Monolithic route enum.** One `Router` enum with ~25 cases plus a matching `goToXxx()` helper per case, and a giant `switch` in `EduVerse360App.swift`. Every new screen edits 3 places in app-level files.
3. **No role-aware navigation.** `StartView` hardcodes `MainTabView(role: .teacher)` (EduVerse360App.swift:96,105). `UserSession.role` exists but is never set; the role from login (`UserModel.role`, a `String`) is never persisted, so every user sees teacher tabs.
4. **Single shared navigation stack.** All tabs live inside the one root `NavigationStack`, so popping back from a detail screen can return to the root instead of staying inside the tab.
5. **Delete modeled as navigation.** `.deleteClass`, `.deleteSection`, `.deleteOnlineClass` are push destinations with dedicated `DeleteXxxView` screens; deletion should be a confirmation action, not a place you navigate to.

## Goals

- Adding a screen touches only the feature folder that owns it (route enum case + view destination registration), never app-level router files.
- Correct tabs per role after login, relaunch, and logout→login as a different role.
- Back/forward navigation stays inside the tab where it started.
- One navigation mechanism everywhere (path-based pushes); the `AuthScreen` switch is removed.
- Non-goals (out of scope): deep links, state restoration across relaunch, coordinator/flow pattern, Keychain token storage.

## Design

### 1. App entry — single auth gate

- `StartView` switches **only** on `session.isLoggedIn`.
- **Logged out:** a `NavigationStack` with `LoginView()` as its root. Destinations are registered for a new `AuthRoute` enum:
  - `register` → `RegisterSessionView()`
  - `verifyRegistrationOTP(email:)` → `VerifyRegistrationView(email:)`
  - `forgotPassword` → `ForgotPasswordView()`
  - `verifyOtp(email:)` → `VerifyOtpView(email:)`
  - `resetPassword(email:)` → `ResetPasswordView(email:)`
- **Logged in:** `MainTabView()` with no `role:` argument; it reads the role from `UserSession` (see §4).
- The `AuthScreen` enum, `NavigationRouter.authScreen`, and `goToMainTab()/goToLogin()/goToRegister()/goToVerifyOtp()` are deleted. Login success now sets `session` state instead of flipping `authScreen`.

### 2. Per-tab navigation stacks

- New `AppTab` enum: `home`, `work`, `students`, `teachers`, `settings`. `MainTabView` maps each `UserRole` to its ordered list of `AppTab` values (replacing today's inline `switch role` with duplicated tab bodies); the tab item label/icon comes from the `AppTab` itself so role tab sets stop drifting apart.
- New `TabRouter` (`@Observable`) holding one `NavigationPath` per tab: `private(set) var paths: [AppTab: NavigationPath]`, with `push(_ route: some Hashable, in tab: AppTab)`, `pop(in:)`, and `popToRoot(in:)`. Only the currently selected tab's path is ever mutated in practice.
- Each tab's root view is wrapped in its own `NavigationStack(path:)` bound to its tab's path, so push/pop is scoped to that tab.
- Feature destinations are registered through a shared view modifier (e.g. `withFeatureDestinations()`) applied inside each tab's `NavigationStack`, so each feature's `.navigationDestination` registration is written once, not per tab.

### 3. Per-feature route enums

The `Router` enum dissolves into smaller enums, each owned by its feature folder:

| Route enum | Cases (carried over from `Router`, renamed for consistency) |
|---|---|
| `AuthRoute` | register, verifyRegistrationOTP(email:), forgotPassword, verifyOtp(email:), resetPassword(email:) |
| `ClassRoute` | list (`allClasses`), create (`classes`), detail(classId: String), update(id: String) |
| `SectionRoute` | list, create(classId: String), classSections(classId: String), detail(id: Int), update(id: Int) |
| `OnlineClassRoute` | create, list, detail(id: Int), update(id: Int) |
| `AssignmentRoute` | create, detail(id: Int) |
| `SharedRoute` | profile, studentDetails(id: Int), teacherDetails(id: Int) |

- ID parameter types are normalized where trivially safe (kept `String`/`Int` as today to avoid model churn; note `ClassByIdView` already takes `String`).
- All `goToXxx()` helpers are replaced by a single `push(_:)` on the owning router and `pop()` / `popToRoot()`.
- **Delete flows become actions, not destinations.** The `DeleteXxxView` screens and `.deleteClass/.deleteSection/.deleteOnlineClass` route cases are removed; list/detail views get a delete affordance (confirmation dialog → view model delete call → refresh list / pop). This is a small UX change bundled into the migration.

### 4. Role persistence

- `UserDefaultsManager` gains `.role` (String rawValue) and `.user` (JSON-encoded `UserModel`) keys alongside `.token`.
- On successful login and register, the login/register view models persist token (already done), user JSON, and role rawValue via `UserSession`.
- `UserSession` restores `token`, `user`, and `role` at launch; `logout()` clears all three plus resets `TabRouter` paths. A convenience `var roleEnum: UserRole?` maps the persisted raw value, with `UserModel.role` parsing through `UserRole(rawValue:)`; missing/unparseable role falls back to `.student`.
- `MainTabView` and `StartView` consume `session.roleEnum`; the `role:` initializer parameter is removed.

### 5. Migration mechanics

1. Create `AuthRoute`, `AppTab`, `TabRouter`, and the feature route enums.
2. Register destinations: auth stack in the app entry; feature destinations via the shared modifier on tab stacks.
3. Update every view that uses `@Environment(NavigationRouter.self)` to use the owning router (auth router pre-login, `TabRouter` in tabs) and replace `router.goToXxx(...)` calls with `router.push(...)`.
4. Convert the three delete screens to confirmation-action flows in their owning list/detail views.
5. Wire role persistence into `UserSession` + login/register view models.
6. Delete `Router`, `AuthScreen`, the old `NavigationRouter`, and the per-case helpers. `EduVerse360App.swift` shrinks to session/router setup, the root switch, and `AuthRoute` registration.
7. Update AGENTS.md navigation section to describe the new structure.

No changes to `Core/Network` or any API layer code.

## Error handling

- Unchanged conventions: view models surface `errorMessage: String?`; delete failures show the same message pattern as existing screens.
- If the persisted role is missing or unknown, the app falls back to `.student` tabs rather than blocking launch.

## Testing / verification

- There are no test targets in the project; verification is build + manual.
- `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build` must pass cleanly (also compiles against the Release deployment target, 26.2).
- Manual pass against the local backend (`http://localhost:3000`):
  - Login as teacher → teacher tabs; relaunch → same tabs; logout → login screen.
  - Login as school admin → admin tabs (proves role is no longer hardcoded).
  - From a tab, push to a detail screen, pop — lands back in the same tab; switch tabs and back — stack state preserved.
  - Register flow: register → OTP → login state; forgot/reset password pushes work.

## Risks / trade-offs

- **Every view file that navigates is touched.** The diff is wide but mechanical; the build catches missed call sites.
- **Tab destination registration** must be applied per tab stack; the shared modifier keeps this to one application point per stack.
- **Role in UserDefaults can go stale** if the backend changes a user's role; acceptable at this stage (token is already in UserDefaults).
- **Delete UX change** (dialog instead of a delete screen) is bundled in; if a dedicated delete screen is preferred it can stay, but it should not be a route.
