# Navigation & Routing Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the monolithic `Router` enum + single shared navigation stack with per-feature route enums, per-tab `NavigationStack`s, a single auth-gated root, and persisted user role.

**Architecture:** New `AuthRouter` (single path for the logged-out flow) and `TabRouter` (one `NavigationPath` per `AppTab`, pushes scoped to the selected tab). The `Router` enum dissolves into `AuthRoute`, `ClassRoute`, `SectionRoute`, `OnlineClassRoute`, `AssignmentRoute`, `SharedRoute`, each owned by its feature folder. `StartView` switches only on `session.isLoggedIn`; `MainTabView` derives its tabs from `session.activeRole`. Delete screens become confirmation dialogs on the detail views.

**Tech Stack:** SwiftUI, Observation (`@Observable`), Swift 5, iOS 17.6+ (Debug) / 26.2 (Release). No external dependencies.

**Spec:** `docs/superpowers/specs/2026-09-12-navigation-routing-design.md`

## Global Constraints

- Every new file starts with the header block: `//  <FileName>.swift` / `//  EduVerse360` / `//  Created by Ekta Rai on 12/09/2026.`.
- Routers are `@Observable` classes (Observation framework), matching existing ViewModel style.
- The project uses folder-synchronized groups: new `.swift` files under `EduVerse360/` are compiled automatically — do NOT edit `project.pbxproj`.
- Build verification after every task: `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build` — must exit 0 before committing.
- English only; no new dependencies; match the conventions of the specific feature folder being edited.
- The app is not fully functional end-to-end until Task 11 (old `NavigationRouter` is still injected as `legacyRouter` until then). Build-green per task is the gate, full manual QA happens in Task 11.
- Verification commands run from the repo root: `/Users/ektarai/Desktop/EduVerse360`.

## Route & call-site reference (used throughout the migration tasks)

Old → new mapping for every navigation call in the app:

| File:line | Old call | New call |
|---|---|---|
| LoginView.swift:122 | `router.goToForgotPassword()` | `router.push(.forgotPassword)` (AuthRouter) |
| LoginView.swift:151 | `router.goToMainTab()` | delete — `session.loginSucceeded(user:)` handles the transition |
| LoginView.swift:223 | `router.goToRegister()` | `router.push(.register)` (AuthRouter) |
| RegisterSessionView.swift:333 | `router.goToLogin()` | `router.popToRoot()` (AuthRouter) |
| RegisterSessionView.swift:365 | `router.goToVerifyRegisterationOTP(email:)` | `router.push(.verifyRegistrationOTP(email: viewModel.email))` (AuthRouter) |
| VerifyRegistrationView.swift:50 | `router.goToLogin()` | `router.popToRoot()` (AuthRouter) |
| ForgotPasswordView.swift:60 | `router.goToVerifyOtp(email:)` | `router.push(.verifyOtp(email: viewModel.email))` (AuthRouter) |
| ForgotPasswordView.swift:88 | `router.goToLogin()` | `router.popToRoot()` (AuthRouter) |
| VerifyOtpView.swift:61 | `router.goToResetPassword(email:)` | `router.push(.resetPassword(email: viewModel.email))` (AuthRouter) |
| ResetPasswordView.swift:73, 101 | `router.goToLogin()` | `router.popToRoot()` (AuthRouter) |
| AllClassesView.swift:45 | `router.goToAllOnlineClass()` | `router.push(OnlineClassRoute.list)` |
| AllClassesView.swift:59 | `router.goToClasses()` | `router.push(ClassRoute.create)` |
| AllClassesView.swift:76 | `router.goToClassById(id:)` | `router.push(ClassRoute.detail(id: "\(classItem.id)"))` |
| ClassView.swift:40 | `router.goToAllClasses()` | `router.push(ClassRoute.list)` |
| ClassByIdView.swift:31 | `router.goToUpdateClass(id:)` | `router.push(ClassRoute.update(id: classId))` |
| ClassByIdView.swift:42 | `router.goToDeleteClass(id:)` | confirmation dialog (Task 4) |
| ClassByIdView.swift:52 | `router.goToCreateSection(id:)` | `router.push(SectionRoute.create(classId: classId))` |
| ClassByIdView.swift:63 | `router.goToListSection()` | `router.push(SectionRoute.list)` |
| ClassByIdView.swift:74 | `router.goToClassSection(id:)` | `router.push(SectionRoute.classSections(classId: classId))` |
| ListSectionView.swift:34 | `router.goToSectionById(id:)` | `router.push(SectionRoute.detail(id: <existing expr>))` |
| SectionByIdView.swift:36 | `router.goToUpdateSection(id:)` | `router.push(SectionRoute.update(id: sectionId))` |
| SectionByIdView.swift:46 | `router.goToDeleteSection(id:)` | confirmation dialog (Task 5) |
| ListOnlineClassView.swift:138 | `router.goToOnlineClassById(id:)` | `router.push(OnlineClassRoute.detail(id: onlineClass.id))` |
| ListOnlineClassView.swift:213 | `router.goToOnlinceClass()` | `router.push(OnlineClassRoute.create)` |
| OnlineClassByIdView.swift:318 | `router.goToUpdateOnlineClass(id:)` | `router.push(OnlineClassRoute.update(id: onlineClassId))` |
| OnlineClassByIdView.swift:328 | `router.goToDeleteOnlineClass(id:)` | confirmation dialog (Task 6) |
| AllTeacherAssignmentView.swift:25 | `router.goToCreateAssigniment()` | `router.push(AssignmentRoute.create)` |
| AllTeacherAssignmentView.swift:99 | `router.goToTeacherAssignmentById(id:)` | `router.push(AssignmentRoute.detail(id: assignment.id))` |
| StudentsListView.swift:40 | `router.goToStudentDetail(id:)` | `router.push(SharedRoute.studentDetails(id: student.id))` |
| TeachersListView.swift:43 | `router.goToTeacherDetail(id:)` | `router.push(SharedRoute.teacherDetails(id: teacher.id))` |
| SettingsView.swift:27 | `router.goToProfile()` | `router.push(SharedRoute.profile)` |
| ProfileView.swift:44-47 | `session.logout()` + `router.goToLogin()` | `session.logout()` + `tabRouter.reset()` |

Environment declaration swap for **tab-resident views** (everything except the auth views in the table above):
`@Environment(NavigationRouter.self) private var router` → `@Environment(TabRouter.self) private var router`

Environment declaration swap for **auth views** (Login, RegisterSession, VerifyRegistration, ForgotPassword, VerifyOtp, ResetPassword):
`@Environment(NavigationRouter.self) private var router` → `@Environment(AuthRouter.self) private var router`

---

### Task 1: Route enums, AppTab, AuthRouter, TabRouter

**Files:**
- Create: `EduVerse360/Features/Authentication/Models/AuthRoute.swift`
- Create: `EduVerse360/Features/Class/Router/ClassRoute.swift`
- Create: `EduVerse360/Features/Section/Router/SectionRoute.swift`
- Create: `EduVerse360/Features/Online Class/Router/OnlineClassRoute.swift`
- Create: `EduVerse360/Features/Assignment/Router/AssignmentRoute.swift`
- Create: `EduVerse360/Shared/Router/SharedRoute.swift`
- Create: `EduVerse360/App/AppTab.swift`
- Create: `EduVerse360/App/AuthRouter.swift`
- Create: `EduVerse360/App/TabRouter.swift`

**Interfaces:**
- Consumes: `UserRole` (`Features/Authentication/Models/UserModel.swift`), existing tab root views (`HomeView`, `TeacherOnlyView`, `StudentsListView`, `AllClassesView`, `TeachersListView`, `AllTeacherAssignmentView`, `SettingsView`).
- Produces (used by Tasks 3-11):
  - `enum AuthRoute: Hashable` — cases `register`, `verifyRegistrationOTP(email: String)`, `forgotPassword`, `verifyOtp(email: String)`, `resetPassword(email: String)`
  - `enum ClassRoute: Hashable` — cases `create`, `list`, `detail(id: String)`, `update(id: String)`
  - `enum SectionRoute: Hashable` — cases `list`, `create(classId: String)`, `classSections(classId: String)`, `detail(id: Int)`, `update(id: Int)`
  - `enum OnlineClassRoute: Hashable` — cases `create`, `list`, `detail(id: Int)`, `update(id: Int)`
  - `enum AssignmentRoute: Hashable` — cases `create`, `detail(id: Int)`
  - `enum SharedRoute: Hashable` — cases `profile`, `studentDetails(id: Int)`, `teacherDetails(id: Int)`
  - `enum AppTab: String, Hashable` — cases `home`, `work`, `classes`, `students`, `teachers`, `settings`; members `var title: String`, `var icon: String`, `func rootView(role: UserRole) -> some View`, `static func tabs(for role: UserRole) -> [AppTab]`
  - `@Observable final class AuthRouter` — `var path: NavigationPath`, `func push<V: Hashable>(_ value: V)`, `func pop()`, `func popToRoot()`
  - `@Observable final class TabRouter` — `var selection: AppTab`, `func binding(for tab: AppTab) -> Binding<NavigationPath>`, `func push<V: Hashable>(_ value: V)`, `func pop()`, `func popToRoot()`, `func reset()`

- [ ] **Step 1: Create the six route enums**

`EduVerse360/Features/Authentication/Models/AuthRoute.swift`:

```swift
//
//  AuthRoute.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation

enum AuthRoute: Hashable {
    case register
    case verifyRegistrationOTP(email: String)
    case forgotPassword
    case verifyOtp(email: String)
    case resetPassword(email: String)
}
```

`EduVerse360/Features/Class/Router/ClassRoute.swift`:

```swift
//
//  ClassRoute.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation

enum ClassRoute: Hashable {
    case create
    case list
    case detail(id: String)
    case update(id: String)
}
```

`EduVerse360/Features/Section/Router/SectionRoute.swift`:

```swift
//
//  SectionRoute.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation

enum SectionRoute: Hashable {
    case list
    case create(classId: String)
    case classSections(classId: String)
    case detail(id: Int)
    case update(id: Int)
}
```

`EduVerse360/Features/Online Class/Router/OnlineClassRoute.swift`:

```swift
//
//  OnlineClassRoute.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation

enum OnlineClassRoute: Hashable {
    case create
    case list
    case detail(id: Int)
    case update(id: Int)
}
```

`EduVerse360/Features/Assignment/Router/AssignmentRoute.swift`:

```swift
//
//  AssignmentRoute.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation

enum AssignmentRoute: Hashable {
    case create
    case detail(id: Int)
}
```

`EduVerse360/Shared/Router/SharedRoute.swift`:

```swift
//
//  SharedRoute.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation

enum SharedRoute: Hashable {
    case profile
    case studentDetails(id: Int)
    case teacherDetails(id: Int)
}
```

- [ ] **Step 2: Create AppTab**

`EduVerse360/App/AppTab.swift`:

```swift
//
//  AppTab.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import SwiftUI

enum AppTab: String, Hashable {
    case home
    case work
    case classes
    case students
    case teachers
    case settings

    var title: String {
        switch self {
        case .home: return "Home"
        case .work: return "Work"
        case .classes: return "Classes"
        case .students: return "Students"
        case .teachers: return "Teachers"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house"
        case .work: return "text.document"
        case .classes: return "applepencil.tip"
        case .students: return "graduationcap.fill"
        case .teachers: return "person.3"
        case .settings: return "gearshape"
        }
    }

    @ViewBuilder
    func rootView(role: UserRole) -> some View {
        switch self {
        case .home:
            HomeView()
        case .work:
            switch role {
            case .teacher:
                AllTeacherAssignmentView()
            default:
                TeacherOnlyView()
            }
        case .classes:
            switch role {
            case .teacher:
                TeacherOnlyView()
            default:
                AllClassesView()
            }
        case .students:
            StudentsListView()
        case .teachers:
            TeachersListView()
        case .settings:
            SettingsView()
        }
    }

    static func tabs(for role: UserRole) -> [AppTab] {
        switch role {
        case .schoolAdmin, .superAdmin:
            return [.home, .work, .students, .classes, .teachers, .settings]
        case .teacher:
            return [.home, .work, .classes, .students, .settings]
        case .student:
            return [.home, .classes, .settings]
        }
    }
}
```

This preserves today's per-role tab sets from `MainTabView` (schoolAdmin/superAdmin: Home, Teachers Only, Students, Classes, Teachers, Settings; teacher: Home, Work, Classes(TeacherOnly), Students, Settings; student: Home, Classes, Settings).

- [ ] **Step 3: Create AuthRouter and TabRouter**

`EduVerse360/App/AuthRouter.swift`:

```swift
//
//  AuthRouter.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class AuthRouter {
    var path = NavigationPath()

    func push<V: Hashable>(_ value: V) {
        path.append(value)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path = NavigationPath()
    }
}
```

`EduVerse360/App/TabRouter.swift`:

```swift
//
//  TabRouter.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import Foundation
import SwiftUI
import Observation

@Observable
final class TabRouter {
    var selection: AppTab = .home
    private(set) var paths: [AppTab: NavigationPath] = [:]

    func binding(for tab: AppTab) -> Binding<NavigationPath> {
        Binding(
            get: { self.paths[tab] ?? NavigationPath() },
            set: { self.paths[tab] = $0 }
        )
    }

    func push<V: Hashable>(_ value: V) {
        paths[selection, default: NavigationPath()].append(value)
    }

    func pop() {
        paths[selection]?.removeLast()
    }

    func popToRoot() {
        paths[selection] = NavigationPath()
    }

    func reset() {
        paths = [:]
        selection = .home
    }
}
```

- [ ] **Step 4: Build**

Run: `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build`
Expected: exits 0. (`AppTab.rootView` references views that already exist; nothing else changed yet.)

- [ ] **Step 5: Commit**

```bash
git add EduVerse360/Features/Authentication/Models/AuthRoute.swift EduVerse360/Features/Class/Router EduVerse360/Features/Section/Router "EduVerse360/Features/Online Class/Router" EduVerse360/Features/Assignment/Router EduVerse360/Shared/Router EduVerse360/App/AppTab.swift EduVerse360/App/AuthRouter.swift EduVerse360/App/TabRouter.swift
git commit -m "refactor: add per-feature route enums, AppTab, AuthRouter and TabRouter"
```

---

### Task 2: Role persistence in UserSession

**Files:**
- Modify: `EduVerse360/Core/Storage/UserDefaultsManager.swift` (add `.user` / `.role` keys and `Data` save/read)
- Modify: `EduVerse360/App/UserSession.swift` (full rewrite of the class)

**Interfaces:**
- Consumes: `UserDefaultsManager` existing API.
- Produces (used by Tasks 3, 8, 9, 11):
  - `UserDefaultsManager.UserDefaultKeys` gains `case user = "user"`, `case role = "role"`
  - `UserDefaultsManager.save(data: Data, key: UserDefaultKeys)` and `UserDefaultsManager.readData(key: UserDefaultKeys) -> Data?`
  - `UserSession.init()` restores `token`, `user` (JSON-decoded), `role` from UserDefaults
  - `UserSession.activeRole: UserRole` — `role ?? .student`
  - `UserSession.loginSucceeded(user: UserModel)` — sets user/role/token, persists user JSON + role rawValue, sets `isLoggedIn = true`
  - `UserSession.logout()` clears `.token`, `.user`, `.role` and all in-memory fields
  - `UserSession.updateUserModel(model: UserModel?)` is RETAINED for now (LoginView still calls it until Task 9) and removed in Task 9.

- [ ] **Step 1: Add keys and Data accessors to UserDefaultsManager**

In `EduVerse360/Core/Storage/UserDefaultsManager.swift`, add two cases to `UserDefaultKeys`:

```swift
    enum UserDefaultKeys : String{
        case token = "token"
        case refreshToken = "refresh_token"
        case email = "email"
        case firstName = "first_name"
        case lastName = "last_name"
        case rememberMe = "remember_me"
        case user = "user"
        case role = "role"
    }
```

Add a `Data` overload to the save section (after the `Bool` save):

```swift
    func save(data: Data, key:UserDefaultKeys){
        standard.set(data, forKey: key.rawValue)
    }
```

Add a data read to the read section (after the `Bool` read):

```swift
    func readData(key:UserDefaultKeys) -> Data?{
        standard.data(forKey: key.rawValue)
    }
```

- [ ] **Step 2: Rewrite UserSession**

Replace the entire class in `EduVerse360/App/UserSession.swift` (keep the existing file header comment):

```swift
@Observable
class UserSession {
    var username: String?
    var user: UserModel?
    var token: String?
    var role: UserRole?
    var isLoggedIn = false

    var activeRole: UserRole { role ?? .student }

    init() {
        token = UserDefaultsManager.shared.read(key: .token)
        if let data = UserDefaultsManager.shared.readData(key: .user),
           let savedUser = try? JSONDecoder().decode(UserModel.self, from: data) {
            user = savedUser
        }
        if let rawRole = UserDefaultsManager.shared.read(key: .role) {
            role = UserRole(rawValue: rawRole)
        }
        isLoggedIn = (token != nil)
    }

    func loginSucceeded(user: UserModel) {
        self.user = user
        self.role = UserRole(rawValue: user.role)
        self.token = UserDefaultsManager.shared.read(key: .token)
        if let data = try? JSONEncoder().encode(user) {
            UserDefaultsManager.shared.save(data: data, key: .user)
        }
        if let role {
            UserDefaultsManager.shared.save(data: role.rawValue, key: .role)
        }
        isLoggedIn = true
    }

    func logout() {
        UserDefaultsManager.shared.remove(key: .token)
        UserDefaultsManager.shared.remove(key: .user)
        UserDefaultsManager.shared.remove(key: .role)
        username = nil
        user = nil
        token = nil
        role = nil
        isLoggedIn = false
    }

    func updateUserModel(model: UserModel?){
        self.user = model
    }
}
```

Notes:
- `LoginViewModel` already saves the token to UserDefaults before `loginSucceeded` is called (Task 9 wires this), so `loginSucceeded` reads it back rather than taking it as a parameter.
- `UserModel` is `Codable` — `JSONEncoder`/`JSONDecoder` work as-is.

- [ ] **Step 3: Build**

Run: `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build`
Expected: exits 0.

- [ ] **Step 4: Commit**

```bash
git add EduVerse360/Core/Storage/UserDefaultsManager.swift EduVerse360/App/UserSession.swift
git commit -m "feat: persist user and role in UserSession across launches"
```

---

### Task 3: App entry, per-tab stacks, destination registration

**Files:**
- Create: `EduVerse360/App/FeatureDestinations.swift`
- Modify: `EduVerse360/EduVerse360App.swift` (full rewrite)
- Modify: `EduVerse360/Features/Authentication/View/MainTabView/MainTabView.swift` (full rewrite)

**Interfaces:**
- Consumes: everything from Tasks 1-2.
- Produces:
  - `struct FeatureDestinations: ViewModifier` + `extension View { func featureDestinations() -> some View }` — registers `.navigationDestination` for `ClassRoute`, `SectionRoute`, `OnlineClassRoute`, `AssignmentRoute`, `SharedRoute`.
  - `struct StartView: View` — switches on `session.isLoggedIn`; logged-out branch is `AuthStackView`.
  - `struct AuthStackView: View` — `NavigationStack(path: $authRouter.path)` rooted at `LoginView()` with `AuthRoute` destinations.
  - `MainTabView()` — no `role:` parameter; reads `session.activeRole`; one `NavigationStack` per tab.
  - Environment objects injected at app root: `session`, `authRouter`, `tabRouter`, and `legacyRouter` (the old `NavigationRouter`, removed in Task 11).

- [ ] **Step 1: Create FeatureDestinations**

`EduVerse360/App/FeatureDestinations.swift`:

```swift
//
//  FeatureDestinations.swift
//  EduVerse360
//
//  Created by Ekta Rai on 12/09/2026.
//

import SwiftUI

struct FeatureDestinations: ViewModifier {
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: ClassRoute.self) { route in
                switch route {
                case .create:
                    ClassView()
                case .list:
                    AllClassesView()
                case .detail(let classID):
                    ClassByIdView(classId: classID)
                case .update(let classID):
                    UpdateClassView(classId: classID)
                }
            }
            .navigationDestination(for: SectionRoute.self) { route in
                switch route {
                case .list:
                    ListSectionView()
                case .create(let classID):
                    SectionView(classId: classID)
                case .classSections(let classID):
                    ClassSectionView(classId: classID)
                case .detail(let sectionID):
                    SectionByIdView(sectionId: sectionID)
                case .update(let sectionID):
                    UpdateSectionView(sectionId: sectionID)
                }
            }
            .navigationDestination(for: OnlineClassRoute.self) { route in
                switch route {
                case .create:
                    CreateOnlineClassView()
                case .list:
                    ListOnlineClassView()
                case .detail(let onlineClassID):
                    OnlineClassByIdView(onlineClassId: onlineClassID)
                case .update(let onlineClassID):
                    UpdateOnlineClassView(onlineClassId: onlineClassID)
                }
            }
            .navigationDestination(for: AssignmentRoute.self) { route in
                switch route {
                case .create:
                    CreateTeacherAssignmentView()
                case .detail(let assignmentID):
                    TeacherAssignmentByIdView(assignmentId: assignmentID)
                }
            }
            .navigationDestination(for: SharedRoute.self) { route in
                switch route {
                case .profile:
                    ProfileView()
                case .studentDetails(let studentID):
                    StudentDetailView(studentId: studentID)
                case .teacherDetails(let teacherID):
                    TeacherDetailView(teacherId: teacherID)
                }
            }
    }
}

extension View {
    func featureDestinations() -> some View {
        modifier(FeatureDestinations())
    }
}
```

All view initializer signatures above are copied verbatim from the existing `.navigationDestination(for: Router.self)` switch in `EduVerse360App.swift` — do not change them.

- [ ] **Step 2: Rewrite EduVerse360App.swift**

Replace everything after the file header with:

```swift
import SwiftUI

@main
struct EduVerse360App: App {

    @State private var session = UserSession()
    @State private var authRouter = AuthRouter()
    @State private var tabRouter = TabRouter()
    @State private var legacyRouter = NavigationRouter()

    var body: some Scene {
        WindowGroup {
            StartView()
                .environment(session)
                .environment(authRouter)
                .environment(tabRouter)
                .environment(legacyRouter)
        }
    }
}

struct StartView: View {

    @Environment(UserSession.self) private var session

    var body: some View {
        if session.isLoggedIn {
            MainTabView()
        } else {
            AuthStackView()
        }
    }
}

struct AuthStackView: View {

    @Environment(AuthRouter.self) private var authRouter

    var body: some View {
        NavigationStack(path: $authRouter.path) {
            LoginView()
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .register:
                        RegisterSessionView()
                    case .verifyRegistrationOTP(let email):
                        VerifyRegistrationView(email: email)
                    case .forgotPassword:
                        ForgotPasswordView()
                    case .verifyOtp(let email):
                        VerifyOtpView(email: email)
                    case .resetPassword(let email):
                        ResetPasswordView(email: email)
                    }
                }
        }
    }
}
```

- [ ] **Step 3: Rewrite MainTabView.swift**

Replace the `struct MainTabView` body (keep the file header comment) with:

```swift
struct MainTabView: View {

    @Environment(TabRouter.self) private var tabRouter
    @Environment(UserSession.self) private var session

    var body: some View {
        TabView(selection: Binding(
            get: { tabRouter.selection },
            set: { tabRouter.selection = $0 }
        )) {
            ForEach(AppTab.tabs(for: session.activeRole), id: \.self) { tab in
                NavigationStack(path: tabRouter.binding(for: tab)) {
                    tab.rootView(role: session.activeRole)
                        .featureDestinations()
                }
                .tabItem {
                    Label(tab.title, systemImage: tab.icon)
                }
                .tag(tab)
            }
        }
    }
}
```

Remove the old `let role: UserRole` property, the old `switch role` body, and the `#Preview` block (it constructs `MainTabView(role:)` which no longer exists). If the `#Preview` is wanted, replace it with `#Preview { MainTabView() }` — acceptable either way.

- [ ] **Step 4: Build**

Run: `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build`
Expected: exits 0. The old `Router`/`NavigationRouter`/`AuthScreen` still exist in `AppRouter.swift` and are still injected as `legacyRouter`, so unmigrated views still compile. Their navigation will misbehave at runtime until Tasks 4-10 — that is expected.

- [ ] **Step 5: Commit**

```bash
git add EduVerse360/App/FeatureDestinations.swift EduVerse360/EduVerse360App.swift EduVerse360/Features/Authentication/View/MainTabView/MainTabView.swift
git commit -m "refactor: per-tab navigation stacks and auth-gated root view"
```

---

### Task 4: Migrate Class feature (incl. delete-as-dialog)

**Files:**
- Modify: `EduVerse360/Features/Class/View/AllClassesView.swift`
- Modify: `EduVerse360/Features/Class/View/ClassView.swift`
- Modify: `EduVerse360/Features/Class/View/ClassByIdView.swift`
- Modify: `EduVerse360/Features/Class/View/UpdateClassView.swift`
- Delete: `EduVerse360/Features/Class/View/DeleteClassView.swift`

**Interfaces:**
- Consumes: `TabRouter`, `ClassRoute`, `SectionRoute`, `OnlineClassRoute`, `DeleteClassViewModel` (existing: `getClassById(id: String)`, `deleteClass(id: String, req: ClassReq)`, `isDeleteClass: Bool`).
- Produces: nothing new.

- [ ] **Step 1: AllClassesView — env swap, call sites, refresh-on-appear**

- Change line 38 to `@Environment(TabRouter.self) private var router`.
- Line 45: `router.goToAllOnlineClass()` → `router.push(OnlineClassRoute.list)`
- Line 59: `router.goToClasses()` → `router.push(ClassRoute.create)`
- Line 76: `router.goToClassById(id: "\(classItem.id)")` → `router.push(ClassRoute.detail(id: "\(classItem.id)"))`
- Change the list-loading modifier `.task { await viewModel.getAllClasses() }` to `.onAppear { Task { await viewModel.getAllClasses() } }` so the list refreshes after returning from detail/delete.

- [ ] **Step 2: ClassView — env swap, call site**

- Change line 12 to `@Environment(TabRouter.self) private var router`.
- Line 40: `router.goToAllClasses()` → `router.push(ClassRoute.list)`

- [ ] **Step 3: UpdateClassView — env swap only**

- Change line 17 to `@Environment(TabRouter.self) private var router`. If the view calls `router.pop()` after a successful update it keeps working unchanged.

- [ ] **Step 4: ClassByIdView — env swap, call sites, delete dialog**

- Change line 13 to `@Environment(TabRouter.self) private var router`.
- Line 31: `router.goToUpdateClass(id: classId)` → `router.push(ClassRoute.update(id: classId))`
- Line 52: `router.goToCreateSection(id: classId)` → `router.push(SectionRoute.create(classId: classId))`
- Line 63: `router.goToListSection()` → `router.push(SectionRoute.list)`
- Line 74: `router.goToClassSection(id: classId)` → `router.push(SectionRoute.classSections(classId: classId))`
- Line 42 (the Delete button): change the action from `router.goToDeleteClass(id: classId)` to `{ showDeleteConfirmation = true }`.
- First, open `DeleteClassView.swift` and note the exact expression it passes as the `req:` argument of `viewModel.deleteClass(id:req:)` — it is built from fields prefilled by `getClassById`. Reuse that exact expression below. Then add to `ClassByIdView`:

```swift
@State private var deleteViewModel = DeleteClassViewModel()
@State private var showDeleteConfirmation = false
```

Extend the existing `.task` modifier (currently `await viewModel.getClassesById(id: classId)`) to also prefill the delete view model:

```swift
.task {
    await viewModel.getClassesById(id: classId)
    await deleteViewModel.getClassById(id: classId)
}
```

Add the dialog and success alert (on the outermost container, next to the existing `.alert` modifiers):

```swift
.confirmationDialog("Delete this class?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
    Button("Delete", role: .destructive) {
        Task { await deleteViewModel.deleteClass(id: classId, req: <exact req expression from DeleteClassView>) }
    }
    Button("Cancel", role: .cancel) {}
}
.alert("Class deleted", isPresented: $deleteViewModel.isDeleteClass) {
    Button("OK") { router.pop() }
}
```

- [ ] **Step 5: Delete DeleteClassView.swift**

```bash
rm "EduVerse360/Features/Class/View/DeleteClassView.swift"
```
(`DeleteClassViewModel` stays — ClassByIdView now uses it.)

- [ ] **Step 6: Build**

Run: `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build`
Expected: exits 0.

- [ ] **Step 7: Commit**

```bash
git add -A EduVerse360/Features/Class
git commit -m "refactor: migrate Class feature to ClassRoute and dialog-based delete"
```

---

### Task 5: Migrate Section feature (incl. delete-as-dialog)

**Files:**
- Modify: `EduVerse360/Features/Section/View/ListSectionView.swift`
- Modify: `EduVerse360/Features/Section/View/SectionByIdView.swift`
- Modify: `EduVerse360/Features/Section/View/SectionView.swift`
- Modify: `EduVerse360/Features/Section/View/UpdateSectionView.swift`
- Delete: `EduVerse360/Features/Section/View/DeleteSectionView.swift`

**Interfaces:**
- Consumes: `TabRouter`, `SectionRoute`, `DeleteSectionViewModel` (existing: `getSectionById(id: Int)`, `deleteSection(id: Int)`, `isDeleteSuccess: Bool`).
- Produces: nothing new.

- [ ] **Step 1: ListSectionView — env swap, call site, refresh-on-appear**

- Change line 7 to `@Environment(TabRouter.self) private var router`.
- Line 34: `router.goToSectionById(...)` → `router.push(SectionRoute.detail(id: <same argument expression>))`
- Change `.task { await viewModel.getAllSection() }` to `.onAppear { Task { await viewModel.getAllSection() } }`.

- [ ] **Step 2: SectionByIdView — env swap, call sites, delete dialog**

- Change line 11 to `@Environment(TabRouter.self) private var router` (keep the existing spacing fix optional).
- Line 36: `router.goToUpdateSection(id: sectionId)` → `router.push(SectionRoute.update(id: sectionId))`
- Line 46 (Delete button): action → `{ showDeleteConfirmation = true }`. Add:

```swift
@State private var deleteViewModel = DeleteSectionViewModel()
@State private var showDeleteConfirmation = false
```

(`DeleteSectionViewModel.deleteSection(id:)` takes only the id — no prefill needed. `DeleteSectionView` prefills via `getSectionById` only to display fields; the delete call does not use them. Verify this against `DeleteSectionView.swift` before deleting it.)

```swift
.confirmationDialog("Delete this section?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
    Button("Delete", role: .destructive) {
        Task { await deleteViewModel.deleteSection(id: sectionId) }
    }
    Button("Cancel", role: .cancel) {}
}
.alert("Section deleted", isPresented: $deleteViewModel.isDeleteSuccess) {
    Button("OK") { router.pop() }
}
```

- [ ] **Step 3: SectionView and UpdateSectionView — env swap only**

- `SectionView.swift` line 11 and `UpdateSectionView.swift` line 13: `@Environment(NavigationRouter.self)` → `@Environment(TabRouter.self)`.

- [ ] **Step 4: Delete DeleteSectionView.swift**

```bash
rm "EduVerse360/Features/Section/View/DeleteSectionView.swift"
```
(`DeleteSectionViewModel` stays.)

- [ ] **Step 5: Build**

Run: `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build`
Expected: exits 0.

- [ ] **Step 6: Commit**

```bash
git add -A EduVerse360/Features/Section
git commit -m "refactor: migrate Section feature to SectionRoute and dialog-based delete"
```

---

### Task 6: Migrate Online Class feature (incl. delete-as-dialog)

**Files:**
- Modify: `EduVerse360/Features/Online Class/View/ListOnlineClassView.swift`
- Modify: `EduVerse360/Features/Online Class/View/OnlineClassByIdView.swift`
- Modify: `EduVerse360/Features/Online Class/View/UpdateOnlineClassView.swift`
- Delete: `EduVerse360/Features/Online Class/View/DeleteOnlineClassView.swift`

**Interfaces:**
- Consumes: `TabRouter`, `OnlineClassRoute`, `DeleteOnlineClassViewModel` (existing: `deleteOnlineClass(id: Int)`, `isSuccess: Bool`).
- Produces: nothing new.

- [ ] **Step 1: ListOnlineClassView — env swap, call sites, refresh-on-appear**

- Change line 6 to `@Environment(TabRouter.self) private var router`.
- Line 138: `router.goToOnlineClassById(id: onlineClass.id)` → `router.push(OnlineClassRoute.detail(id: onlineClass.id))`
- Line 213: `router.goToOnlinceClass()` → `router.push(OnlineClassRoute.create)`
- Change `.task { await viewModel.getListOnlineClass() }` to `.onAppear { Task { await viewModel.getListOnlineClass() } }`.

- [ ] **Step 2: OnlineClassByIdView — env swap, call sites, delete dialog**

- Change line 6 to `@Environment(TabRouter.self) private var router`.
- Line 318: `router.goToUpdateOnlineClass(id: onlineClassId)` → `router.push(OnlineClassRoute.update(id: onlineClassId))`
- Line 328 (Delete button): action → `{ showDeleteConfirmation = true }`. Add:

```swift
@State private var deleteViewModel = DeleteOnlineClassViewModel()
@State private var showDeleteConfirmation = false
```

(`DeleteOnlineClassViewModel.deleteOnlineClass(id:)` takes only the id — the deleted screen's form prefill was display-only. Verify against `DeleteOnlineClassView.swift` before deleting it.)

```swift
.confirmationDialog("Delete this online class?", isPresented: $showDeleteConfirmation, titleVisibility: .visible) {
    Button("Delete", role: .destructive) {
        Task { await deleteViewModel.deleteOnlineClass(id: onlineClassId) }
    }
    Button("Cancel", role: .cancel) {}
}
.alert("Online class deleted", isPresented: $deleteViewModel.isSuccess) {
    Button("OK") { router.pop() }
}
```

- [ ] **Step 3: UpdateOnlineClassView — env swap only**

- Change line 13 to `@Environment(TabRouter.self) private var router`.

- [ ] **Step 4: Delete DeleteOnlineClassView.swift**

```bash
rm "EduVerse360/Features/Online Class/View/DeleteOnlineClassView.swift"
```
(`DeleteOnlineClassViewModel` stays.)

- [ ] **Step 5: Build**

Run: `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build`
Expected: exits 0.

- [ ] **Step 6: Commit**

```bash
git add -A "EduVerse360/Features/Online Class"
git commit -m "refactor: migrate Online Class feature to OnlineClassRoute and dialog-based delete"
```

---

### Task 7: Migrate Assignment feature

**Files:**
- Modify: `EduVerse360/Features/Assignment/view/AllTeacherAssignmentView.swift`

**Interfaces:**
- Consumes: `TabRouter`, `AssignmentRoute`.
- Produces: nothing new.

- [ ] **Step 1: Env swap and call sites**

- Change line 5 to `@Environment(TabRouter.self) private var router`.
- Line 25: `router.goToCreateAssigniment()` → `router.push(AssignmentRoute.create)`
- Line 99: `router.goToTeacherAssignmentById(id: assignment.id)` → `router.push(AssignmentRoute.detail(id: assignment.id))`

- [ ] **Step 2: Build**

Run: `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build`
Expected: exits 0.

- [ ] **Step 3: Commit**

```bash
git add EduVerse360/Features/Assignment
git commit -m "refactor: migrate Assignment feature to AssignmentRoute"
```

---

### Task 8: Migrate people lists, settings, and profile logout

**Files:**
- Modify: `EduVerse360/Features/Student/View/StudentsListView.swift`
- Modify: `EduVerse360/Features/Teacher/View/TeachersListView.swift`
- Modify: `EduVerse360/Features/Authentication/View/SettingsView.swift`
- Modify: `EduVerse360/Features/Profile/View/ProfileView.swift`

**Interfaces:**
- Consumes: `TabRouter`, `SharedRoute`, `UserSession.logout()` / `TabRouter.reset()` from Task 2.
- Produces: nothing new.

- [ ] **Step 1: StudentsListView — env swap, call site, remove nested NavigationStack**

- Change line 11 to `@Environment(TabRouter.self) private var router`.
- Line 40: `router.goToStudentDetail(id: student.id)` → `router.push(SharedRoute.studentDetails(id: student.id))`
- This view wraps its content in its own inner `NavigationStack` (~line 19) inside what is now a tab-provided `NavigationStack`. Remove the inner `NavigationStack {` wrapper and its matching closing brace, keeping the inner content and its modifiers. The tab's stack now handles navigation.

- [ ] **Step 2: TeachersListView — env swap, call site, remove nested NavigationStack**

- Change line 11 to `@Environment(TabRouter.self) private var router`.
- Line 43: `router.goToTeacherDetail(id: teacher.id)` → `router.push(SharedRoute.teacherDetails(id: teacher.id))`
- Remove the inner `NavigationStack` wrapper the same way as StudentsListView.

- [ ] **Step 3: SettingsView — env swap and call site**

- Change line 13 to `@Environment(TabRouter.self) private var router`.
- Line 27: `router.goToProfile()` → `router.push(SharedRoute.profile)`

- [ ] **Step 4: ProfileView — logout without router**

Replace lines 41-47:

```swift
Button(
    action: {
        session.logout()
        router.goToLogin()
        print("logout successfully")
    }, label: { Text("Logout")... })
```

with — the router environment becomes `TabRouter` (change line 12 to `@Environment(TabRouter.self) private var tabRouter`) and the action becomes:

```swift
Button(
    action: {
        session.logout()
        tabRouter.reset()
        print("logout successfully")
    }, label: { Text("Logout")... })
```

`session.logout()` sets `isLoggedIn = false`, which switches `StartView` back to `AuthStackView` (whose `LoginView` is always the root); `tabRouter.reset()` discards any stale per-tab stacks and tab selection.

- [ ] **Step 5: Build**

Run: `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build`
Expected: exits 0.

- [ ] **Step 6: Commit**

```bash
git add EduVerse360/Features/Student EduVerse360/Features/Teacher EduVerse360/Features/Authentication/View/SettingsView.swift EduVerse360/Features/Profile
git commit -m "refactor: migrate people lists and profile to SharedRoute and TabRouter"
```

---

### Task 9: Migrate auth views and login session wiring

**Files:**
- Modify: `EduVerse360/Features/Authentication/Login/View/LoginView.swift`
- Modify: `EduVerse360/Features/Authentication/Login/ViewModel/LoginViewModel.swift`
- Modify: `EduVerse360/Features/Authentication/Register/View/RegisterSessionView.swift`
- Modify: `EduVerse360/Features/Authentication/Register/View/VerifyRegistrationView.swift`
- Modify: `EduVerse360/Features/Authentication/ForgotPassword/View/ForgotPasswordView.swift`
- Modify: `EduVerse360/Features/Authentication/ForgotPassword/View/VerifyOtpView.swift`
- Modify: `EduVerse360/Features/Authentication/ResetPassword/View/ResetPasswordView.swift`

**Interfaces:**
- Consumes: `AuthRouter`, `AuthRoute`, `UserSession.loginSucceeded(user:)` from Task 2.
- Produces: nothing new.

- [ ] **Step 1: LoginView — env stays AuthRouter, rewire success and auth call sites**

- Change line 28 to `@Environment(AuthRouter.self) private var router`.
- Line 122: `router.goToForgotPassword()` → `router.push(.forgotPassword)`
- Line 223: `router.goToRegister()` → `router.push(.register)`
- Replace the success block (lines 143-154) with:

```swift
Task {
    await viewModel.loginUser()
    if viewModel.isLoginSucceess {
        session.loginSucceeded(user: viewModel.userModel)
    }
}
```

(`router.goToMainTab()` is deleted; `StartView` switches to `MainTabView()` automatically when `isLoggedIn` becomes true. Keep the existing `session` environment property — it is already declared in this view.)

- [ ] **Step 2: LoginViewModel — remove now-unused session helpers**

Delete `updateUsername(sess:)`, `saveToken(sess:)`, and `updateUserModel(sess:)` (LoginViewModel.swift ~46-57) — LoginView no longer calls them; `session.loginSucceeded(user:)` handles session state. Keep the token save inside `loginUser()` (`UserDefaultsManager.shared.save(data: loginResponse.token, key: .token)`) — `loginSucceeded` reads it back from UserDefaults.

- [ ] **Step 3: RegisterSessionView and VerifyRegistrationView**

- `RegisterSessionView.swift`: change line 11 to `@Environment(AuthRouter.self) private var router`. Line 333: `router.goToLogin()` → `router.popToRoot()`. Line 365: `router.goToVerifyRegisterationOTP(email: viewModel.email)` → `router.push(.verifyRegistrationOTP(email: viewModel.email))`.
- `VerifyRegistrationView.swift`: change line 11 to `@Environment(AuthRouter.self) private var router`. Line 50: `router.goToLogin()` → `router.popToRoot()`.

- [ ] **Step 4: ForgotPasswordView, VerifyOtpView, ResetPasswordView**

- `ForgotPasswordView.swift`: change line 12 to `@Environment(AuthRouter.self) private var router`. Line 60: `router.goToVerifyOtp(email: viewModel.email)` → `router.push(.verifyOtp(email: viewModel.email))`. Line 88: `router.goToLogin()` → `router.popToRoot()`.
- `VerifyOtpView.swift`: change line 14 to `@Environment(AuthRouter.self) private var router`. Line 61: `router.goToResetPassword(email: viewModel.email)` → `router.push(.resetPassword(email: viewModel.email))`.
- `ResetPasswordView.swift`: change line 15 to `@Environment(AuthRouter.self) private var router`. Lines 73 and 101: `router.goToLogin()` → `router.popToRoot()`.

- [ ] **Step 5: Build**

Run: `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build`
Expected: exits 0.

- [ ] **Step 6: Commit**

```bash
git add EduVerse360/Features/Authentication
git commit -m "refactor: migrate auth flow to AuthRoute and session-driven root switch"
```

---

### Task 10: Remove legacy router and update docs

**Files:**
- Delete: `EduVerse360/App/AppRouter.swift`
- Modify: `EduVerse360/EduVerse360App.swift` (remove `legacyRouter`)
- Modify: `AGENTS.md` (navigation section)

**Interfaces:**
- Consumes: everything from Tasks 1-9.
- Produces: final state — no `Router`, `AuthScreen`, or `NavigationRouter` anywhere.

- [ ] **Step 1: Verify no remaining references**

Run: `grep -rn "NavigationRouter\|AuthScreen\|Router\." EduVerse360 --include="*.swift"`
Expected: zero matches (the `Router.` pattern catches `Router.case` usages; `AuthRouter`/`TabRouter` contain "Router" as substring but not `NavigationRouter`). Also run: `grep -rn "goTo" EduVerse360 --include="*.swift"` — expected zero matches. Fix any stragglers found.

- [ ] **Step 2: Delete AppRouter.swift and remove legacyRouter**

```bash
rm EduVerse360/App/AppRouter.swift
```

In `EduVerse360/EduVerse360App.swift` remove the `@State private var legacyRouter = NavigationRouter()` line and the `.environment(legacyRouter)` modifier.

- [ ] **Step 3: Build (Debug) and also compile-check Release deployment target**

Run: `xcodebuild -project EduVerse360.xcodeproj -scheme EduVerse360 -configuration Debug build`
Expected: exits 0. This is the primary gate; the Release deployment target (26.2) compiles the same sources and is covered by the same Swift language mode — if a Debug build passes, Release sources compile (Release *deployment* issues would only appear at link/device stages, out of scope here).

- [ ] **Step 4: Update AGENTS.md**

Update the "Navigation" section of `AGENTS.md` to describe the new system: `AuthRouter` (logged-out stack, `AuthRoute` destinations, root `LoginView`), `TabRouter` (per-`AppTab` paths, `push`/`pop`/`popToRoot`/`reset`), per-feature route enums (`ClassRoute`, `SectionRoute`, `OnlineClassRoute`, `AssignmentRoute`, `SharedRoute`) registered via `featureDestinations()` on each tab's `NavigationStack`, `StartView` switching on `session.isLoggedIn`, `MainTabView` deriving tabs from `session.activeRole`, and the two-step rule for adding a screen now being: add a case to the feature's route enum + a destination in `FeatureDestinations.swift` (plus a `push` call at the call site). Remove the paragraph describing `Router`/`AuthScreen` and the old two-step rule.

- [ ] **Step 5: Commit**

```bash
git add -A
git commit -m "refactor: remove legacy NavigationRouter and AuthScreen"
```

- [ ] **Step 6: Manual verification against the local backend**

Requires the backend running at `http://localhost:3000` and a simulator. Verify:
1. Login as **teacher** → teacher tabs (Home, Work, Classes, Students, Settings). Fully quit and relaunch the app → teacher tabs again (proves role persistence).
2. Logout → login screen. Login as **school admin** (register one first if needed, role `school_admin`) → admin tabs (proves role is no longer hardcoded).
3. Classes tab → open a class detail → Update → save → back lands on the detail; back again lands on the class list inside the same tab.
4. Classes tab → class detail → Delete → confirmation dialog → Delete → success alert → OK lands on the refreshed class list (deleted item gone).
5. From Classes tab, push to Online Class list → back returns to Classes tab, tab selection preserved.
6. Sections: same push/pop + delete-dialog pass on section detail.
7. Assignments (teacher Work tab) → create assignment → appears in list; tap → detail.
8. Students/Teachers tabs → tap a row → detail; back returns to the list (nested-stack fix).
9. Settings → Profile → Logout → login screen.
10. Register a new account → OTP screen → after OK, back at Login → login works.
11. Forgot Password → OTP → Reset Password → OK lands at Login.

---

## Self-Review Notes

- **Spec coverage:** §1 auth gate → Tasks 3, 9; §2 per-tab stacks → Tasks 1, 3; §3 route enums + delete-as-action → Tasks 1, 4, 5, 6; §4 role persistence → Task 2 (+ consumed in 3, 8, 9); §5 migration + AGENTS.md → Tasks 4-11. Error handling (role fallback → `.student`) → Task 2 `activeRole`. Verification (build + manual pass) → per-task builds + Task 11 Step 6.
- **Placeholder scan:** all code blocks are complete; the only repo-anchored lookups are the exact `req:` expression in `DeleteClassView` (Task 4) and the inner-`NavigationStack` brace locations (Task 8), both explicitly anchored to existing files that the executor opens before editing.
- **Type consistency:** `TabRouter.push/pop/popToRoot/reset/binding(for:)/selection`, `AuthRouter.push/pop/popToRoot/path`, `UserSession.loginSucceeded(user:)/activeRole/logout()`, route case names (`detail(id:)`, `update(id:)`, `create(classId:)`, `classSections(classId:)`, `verifyRegistrationOTP(email:)`), and `AppTab.tabs(for:)/rootView(role:)` are used identically in every task that references them.
