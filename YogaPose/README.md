# Yoga Pose Library (SwiftUI, MVVM)

iPhone-only app. Requires **Xcode 16+**, iOS 17+.

## Run
1. Open `YogaPoseLibrary.xcodeproj`.
2. Select an iPhone simulator and press **Run** (⌘R).
   For a real device: Target → Signing & Capabilities → choose your Team.
3. Simulator Face ID: **Features → Face ID → Enrolled**, then **Matching Face**.
   If not enrolled, the username/password fallback appears (first use creates a local account, min 6 chars).

## Structure
```
YogaPoseLibrary/
├── App/         YogaPoseLibraryApp, RootView, MainTabView
├── Models/      Pose, PoseCategory, DifficultyLevel, SamplePoseData
├── Services/    PoseRepository (single source of truth), PoseStorageService (JSON),
│                BiometricService (Face ID), CredentialService (Keychain)
├── ViewModels/  Auth, Dashboard, PoseList, PoseDetail, PoseForm
├── Views/       Auth, Dashboard, PoseList, PoseDetail, PoseForm, Components
└── Resources/   Assets.xcassets (AppIcon, AccentColor)
```

## Feature map
| # | Feature | Where |
|---|---------|-------|
| 1 | Face ID + password fallback | AuthViewModel, LoginView |
| 2 | Dashboard | DashboardViewModel, DashboardView |
| 3 | Pose list | PoseListView, PoseCardView |
| 4 | Add pose | PoseFormView / PoseFormViewModel (.add) |
| 5 | Pose details | PoseDetailView |
| 6 | Edit pose | PoseFormView (.edit) |
| 7 | Delete pose | swipe / context menu / detail menu, with confirmation |
| 8 | Search & filter | PoseListViewModel (name search, category chips, difficulty menu) |
| 9 | Practice counter | "Practised Today" button, swipe action; Never Practised highlighted |

Data is saved to `Documents/poses.json`. Poses are seeded on first launch.
