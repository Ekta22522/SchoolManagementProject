# AGENTS.md

Guidance for AI coding agents working in this repository. Everything below was verified against the actual codebase; do not assume anything beyond what is documented here.

## Project overview

**EduVerse360** is a native iOS school-management app written in **SwiftUI** (Swift 5). It is the mobile client for a REST backend (currently a local Node-style API at `http://localhost:3000`). Implemented features so far: authentication (login, register with OTP, forgot/reset password), classes CRUD, sections CRUD, online classes CRUD, teacher assignments (create/list/detail, incl. PDF attachments), students/teachers lists and details, and a profile screen.

- Single Xcode project: `EduVerse360.xcodeproj`, one app target named `EduVerse360`.
- Bundle ID: `com.makeapple.HuliPizaa.EduVerse360`; devices: iPhone + iPad.
- iOS deployment target is 17.6 in Debug and 26.2 in Release (`project.pbxproj`) — code must compile against both.
- **No external dependencies** (no Swift Package Manager, CocoaPods, or Carthage). Only Apple frameworks (SwiftUI, Foundation, Observation, PDFKit via the assignment PDF viewer).
- **No unit/UI test targets, no CI configuration, no lint configuration** exist yet.
- The project uses Xcode's *folder-synchronized groups* (`PBXFileSystemSynchronizedRootGroup`): any `.swift` file placed under the `EduVerse360/` folder on disk is compiled automatically — you do **not** need to add files to `project.pbxproj`.

## Repository layout

```
EduVerse360/
├── EduVerse360App.swift   # @main entry point: NavigationStack + all .navigationDestination registrations
├── ContentView.swift      # sample/starter view, not the real root
├── App/                   # app-wide plumbing
│   ├── AuthRouter.swift   # @Observable AuthRouter (logged-out NavigationPath, push/pop/popToRoot)
│   ├── TabRouter.swift    # @Observable TabRouter (per-AppTab paths, push/pop/popToRoot/reset)
│   ├── AppTab.swift       # AppTab enum (tabs per role, rootView(role:), title/icon)
│   ├── FeatureDestinations.swift  # featureDestinations() modifier registering all route enums
│   ├── UserSession.swift  # @Observable UserSession (token, user, role, activeRole, isLoggedIn)
│   ├── LoadingView.swift, Spinner.swift, AppTextField.swift
├── Core/
│   ├── Network/           # APIClient, APIEndpoint, RequestBuilder, HTTPMethod,
│   │                      # HTTPHeaders, APIResponse, MultipartFormData, AppConfiguration, Environment
│   └── Storage/           # UserDefaultsManager
├── Shared/
│   ├── Theme/             # Color(hex:) helpers, AppColors
│   └── Data/              # UsersDB.swift
├── Features/              # one folder per feature domain, MVVM
│   ├── Authentication/    # Login, Register, ForgotPassword, ResetPassword,
│   │                      # Models (UserModel, UserRole), Home/Settings/Dashboard, MainTabView
│   ├── Class/             # create/list/detail/update/delete
│   ├── Section/
│   ├── Online Class/      # note: folder name contains a space
│   ├── Assignment/        # teacher assignments + custom cards + PDFScreen/PDFViewer
│   ├── Student/, Profile/
└── Assets.xcassets/
README.md                  # aspirational architecture notes (target structure, not current reality)
```

Note: `README.md` describes a *planned* structure (Domain/Data layers, Keychain, DI, etc.) that does **not** exist in the code. Treat the actual `EduVerse360/` tree as the source of truth.

## Architecture and conventions

MVVM with protocol-based service access, following Swift Concurrency (`async`/`await`):

1. **Model** — plain Codable request/response structs, one per API operation, e.g. `ClassReq` / `ClassRes` / `ClassByIDRes`.
2. **Protocol** — e.g. `ClassProtocol` declares the API calls; `ClassServerAPI` implements them by calling `APIClient.shared.request(...)` with an `APIEndpoint` case.
3. **ViewModel** — `@Observable class XxxViewModel` holding `@Observable`-friendly state (`isLoading`, `errorMessage`, per-field validation errors) and an async method per operation. The service is injectable via the initializer default (`init(classservice: ClassProtocol = ClassServerAPI())`).
4. **View** — SwiftUI views that read the ViewModel and the environment (`UserSession`, `AuthRouter`, `TabRouter`).

Layer responsibilities:

- `Core/Network/APIClient.swift` — singleton (`APIClient.shared`) with `request<T: Decodable>(_:body:)` and `multipartRequest(_:multipart:)`. Uses `URLSession.shared`, checks `200...299`, decodes JSON. Logs heavily with emoji-prefixed `print` statements (🌐 📤 📦 📥 📡 ✅ ❌ 🔥) — this is the established debugging style; keep new network code consistent with it.
- `Core/Network/APIEndpoint.swift` — every backend route is one enum case with `path`, `method`, and `url` computed properties. **When adding an API call, add the case here**; several cases currently return an empty path as placeholders (students, teachers, uploadProfileImage, dashboard) — fill those in rather than creating parallel endpoint definitions.
- `Core/Network/RequestBuilder.swift` — builds the `URLRequest`, sets JSON content type/accept, and attaches `Authorization: Bearer <token>` read from `UserDefaultsManager` (key `.token`). Token storage in UserDefaults (not Keychain) is the current, deliberate implementation.
- `Core/Network/Environment.swift` + `AppConfiguration.swift` — `APIEnvironment` enum (`development` / `staging` / `production`); only `development` (`http://localhost:3000`) has a URL. The active environment is hardcoded as `.development` in `AppConfiguration.environemnt` (note the existing misspelling — match it or fix all call sites).
- Paths in `APIEndpoint` are inconsistent: some start with `/api/...` and some with `api/...`. Both currently work because `URL.appending(path:)` handles relative appends; when editing, normalize to one style.

### Navigation

Navigation is split into a logged-out stack and per-tab stacks:

- `AuthRouter` (@Observable, `App/AuthRouter.swift`) — owns the logged-out `NavigationPath` (`push`/`pop`/`popToRoot`). It backs the `NavigationStack` in `EduVerse360App.swift`, whose root is `LoginView()` and whose destinations are the `AuthRoute` cases (`register`, `verifyRegistrationOTP(email:)`, `forgotPassword`, `verifyOtp(email:)`, `resetPassword(email:)`), defined in `Features/Authentication/Models/AuthRoute.swift`.
- `TabRouter` (@Observable, `App/TabRouter.swift`) — keeps one `NavigationPath` per `AppTab` (`paths: [AppTab: NavigationPath]`, exposed via `binding(for:)`), plus `selection`. Its `push`/`pop`/`popToRoot` operate on the currently selected tab; `reset()` clears all paths and returns to `.home`.
- Per-feature route enums — `ClassRoute`, `SectionRoute`, `OnlineClassRoute`, `AssignmentRoute`, `SharedRoute` — one enum per feature domain, each living in a `Router` folder (`SharedRoute` lives in `Shared/Router`). All of them are registered centrally by the `featureDestinations()` view modifier (`App/FeatureDestinations.swift`), which applies one `.navigationDestination(for:)` per route enum. Every tab's `NavigationStack` in `MainTabView` applies `.featureDestinations()`.
- `StartView` (in `EduVerse360App.swift`) switches on `session.isLoggedIn`: logged in → `MainTabView()`, logged out → `AuthStackView()` (the `AuthRouter` stack). `MainTabView` derives its tabs from the logged-in role via `AppTab.tabs(for: session.activeRole)`, so role handling is dynamic.

**Adding a new screen requires**: (1) add a case to the relevant feature's route enum, and (2) register the destination for that case in `EduVerse360/App/FeatureDestinations.swift` — then push the case from the call site (`router.push(...)` or `authRouter.push(...)`). Only add a new route enum if the screen belongs to a new feature domain.

`UserSession` restores login state from the persisted token at launch (`isLoggedIn = token != nil`) and `logout()` clears it; `activeRole` falls back to `.student` if no role is persisted.

## Backend API surface

Base URL from the active environment; implemented paths include:

- Auth: `POST /api/users/login`, `POST /api/users/register`, `POST /api/users/verify-registration-otp`, `api/users/forgot-password`, `api/users/verify-otp`, `api/users/reset-password`
- Classes: `api/classes` (GET/POST), `api/classes/{id}` (GET/PUT/DELETE)
- Sections: `api/sections` (GET/POST), `api/classes/{id}/sections` (GET), `api/sections/{id}` (GET/PUT/DELETE)
- Online classes: `api/online-classes` (GET/POST), `api/online-classes/{id}` (GET/PUT/DELETE)
- Assignments: `api/assignments` (GET/POST), `api/assignments/{id}` (GET)
- Profile: `GET api/users/me`

Many endpoints are plain HTTP (no TLS) against localhost — fine for development only; there is no certificate pinning or security layer.

## Build and run

There is no package manager or external build tool — use Xcode or `xcodebuild`:

```bash
# Build from the command line
xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build

# List targets/configurations
xcodebuild -list -project EduVerse360.xcodeproj
```

- Scheme `EduVerse360` exists (auto-generated); configurations are `Debug` and `Release` (Release is the `xcodebuild` default when unspecified).
- Because the app talks to `http://localhost:3000`, the backend must be running locally for any feature to work end-to-end, and the simulator talks to the Mac's localhost.
- To ship/test against another backend, change `AppConfiguration.environemnt` (staging/production URLs are currently empty).

## Testing

There are **no tests in the repo** (no test targets, no test folders). Do not claim a change is tested unless you added a test target yourself. Verification today means: the project builds cleanly (`xcodebuild ... build`) and the changed feature works against the local backend.

## Code style guidelines

Observed conventions — match them when editing:

- Every file starts with the header comment block `//  <FileName>.swift` / `//  EduVerse360` / `//  Created by Ekta Rai on <date>.`.
- English is the only language used in code, comments, and docs.
- Types are `final class` / `class` / `struct` as in surrounding files; singletons use `static let shared` + `private init()`.
- ViewModels are `@Observable` classes (Observation framework), not `ObservableObject`/`@Published`.
- Errors are surfaced as `errorMessage: String?` on the ViewModel, set from `error.localizedDescription`.
- Async API work uses `async throws` + `try await`; loading flags are toggled with `defer { isLoading = false }`.
- Heavy `print`-based logging with emoji markers is the norm in network and ViewModel code.
- Naming is inconsistent in places (e.g. `View` vs `Views`, `ViewModel` vs `ViewModels`, `Protocol` vs `Protocols`, folder `view` lowercase). Follow the convention of the *specific feature folder* you are editing rather than "fixing" it globally.
- A few intentional-looking quirks exist (typo `environemnt`, `ClsssRes.swift`, `ResetPassowrdProtocol.swift`); rename only if you update every reference.

## Security considerations

- Auth tokens are stored in `UserDefaults` (`UserDefaultsManager`), readable by anything on the device — acceptable for the current dev stage, but flag it before any release-hardening task. `README.md` mentions Keychain as the intended future approach.
- Development traffic is plain HTTP to localhost; never point `production` at an `http://` URL.
- The app logs full request/response bodies (including tokens) to the console via `print`. Keep this in mind when handling sensitive data.
- Do not commit real backend URLs, credentials, or API keys; none are currently present.
