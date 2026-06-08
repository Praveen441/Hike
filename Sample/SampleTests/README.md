# SampleTests

Unit tests for the Sample Rick & Morty iOS app.

## Test Files

- `CharacterListViewModelTests.swift` - Tests for CharacterListViewModel
- `CharacterUseCaseTests.swift` - Tests for CharacterUseCase
- `NetworkServiceTests.swift` - Tests for NetworkService

## Adding Test Target to Xcode

### Step 1: Open Project
Open `Sample.xcodeproj` in Xcode

### Step 2: Create Test Target
1. Select the project in the navigator
2. Click "+ Target" (bottom right)
3. Select "Unit Testing Bundle"
4. Name it "SampleTests"
5. Click "Finish"

### Step 3: Configure Test Target
1. In the test target's Build Phases, add test files:
   - CharacterListViewModelTests.swift
   - CharacterUseCaseTests.swift
   - NetworkServiceTests.swift

2. In Build Settings, set:
   - Product Name: SampleTests
   - Test Host: Sample (the main app)
   - Bundle Loader: $(TEST_HOST)

### Step 4: Link to Main App
1. In test target's Build Phases → Link Binary With Libraries
2. Add "Sample" framework

### Step 5: Run Tests
```bash
xcodebuild test -scheme Sample
```

## Current Structure
```
SampleTests/
├── Info.plist
├── README.md
├── CharacterListViewModelTests.swift
├── CharacterUseCaseTests.swift
└── NetworkServiceTests.swift
```
