# Hike
Rick And Morty Assignment

This app follows a 3-layer Clean Architecture: Domain, Data, and Presentation. The Domain layer contains business logic and protocols, the Data layer handles networking and SwiftData caching, and the Presentation layer contains SwiftUI views and ViewModels. Dependency injection is protocol-based, pagination uses infinite scrolling with local search filtering, offline support is provided through SwiftData, and testing mocks only the network layer while exercising real services and repositories. This keeps the codebase highly testable, maintainable, and scalable.

Architecture
1. Domain Layer

Contains business logic and abstractions.

Models

RMCharacter
Episode
Location
CharacterPage

Service

CharacterService
Handles orchestration such as character details + episode fetching

Repository

CharacterRepository
Provides network and cache access

Key Principle

Service = business orchestration
Repository = data access
2. Data Layer

Responsible for:

Networking
Persistence
DTOs

Components:

RequestBuilder
RMEndpoint
NetworkService
DTOs (CharacterDTO, EpisodeDTO)
SwiftData persistence layer

Uses a generic:

execute<T: Decodable>(_ request: RequestBuilder)

for all network requests.

3. Presentation Layer
Views
CharacterListView
CharacterDetailView
CharacterRowView
CachedAsyncImage
ViewModels
CharacterListViewModel
CharacterDetailViewModel
Smaller component ViewModels

Responsibilities:

State management
Pagination
Search filtering
Error handling
Data Flow
Search

Search is performed locally:

User types
→ debounce
→ filter existing data
→ update list

No network request.

Pagination
User reaches n-2 row
→ loadNextPage()
→ fetch page
→ cache results
→ append to list
Character Detail
Open detail
→ fetch character
→ fetch episodes in parallel
→ map to view models
→ update UI
Dependency Injection

Simple protocol-based DI:

View
→ Service
→ Repository
→ NetworkService

No:

Service locators
Factories
Complex containers

Only singleton:

ImageCacheManager
State Management

View:

Owns search text

ViewModel:

Owns filtering logic
Pagination state
Loading state

Uses:

@State
@Published
@MainActor
