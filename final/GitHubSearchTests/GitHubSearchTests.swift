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

    await store.send(.keywordChanged("Swift")) { store in
      store.keyword = "Swift"
    }

    await store.send(.searchButtonTapped) { store in
      store.searchResults = [
        "Swift",
        "SwiftyJSON",
        "SwiftGuide",
        "SwiftterSwift",
      ]
    }
  }
}
