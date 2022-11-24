import XCTest

import ComposableArchitecture

@testable import GitHubSearch

@MainActor
final class GitHubSearchTests: XCTestCase {
  func test_repoSearchResults_whenSearchButtonTapped() async {
    let store = TestStore(
      initialState: RepoSearch.State(),
      reducer: RepoSearch()
    )

    store.dependencies.repoSearchClient.search = { _ in .mock }
    store.dependencies.continuousClock = ImmediateClock()

    await store.send(.keywordChanged("Swift")) { store in
      store.keyword = "Swift"
    }

    await store.receive(.requestRepoSearch) { store in
      store.isLoading = true
    }
    
    await store.receive(.dataLoaded(.success(.mock))) { store in
      store.isLoading = false
      store.searchResults = [
        RepositoryModel.Result(name: "Swift", id: 1),
        RepositoryModel.Result(name: "SwiftLint", id: 2),
        RepositoryModel.Result(name: "SwiftAlgorithm", id: 3)
      ]
    }
  }

  func test_repoSearchResults_whenKeywordCleared() async {
    let store = TestStore(
      initialState: RepoSearch.State(),
      reducer: RepoSearch()
    )
    let clock = TestClock()
    store.dependencies.repoSearchClient.search = { _ in .mock }
    store.dependencies.continuousClock = clock

    await store.send(.keywordChanged("Swift")) { store in
      store.keyword = "Swift"
    }
    await clock.advance(by: .seconds(0.2))

    await store.send(.keywordChanged("")) { store in
      store.keyword = ""
    }

    await store.receive(.cancelRepoSearch)
  }
}
