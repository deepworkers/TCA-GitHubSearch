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

    await store.send(.keywordChanged("Swift")) { store in
      store.keyword = "Swift"
    }

    await store.send(.searchButtonTapped) { store in
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
}
