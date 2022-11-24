import SwiftUI

import ComposableArchitecture

@main
struct GitHubSearchApp: App {
  var body: some Scene {
    WindowGroup {
      RepositorySearchView(
        store: Store(
          initialState: RepositorySearch.State(),
          reducer: RepositorySearch()
        )
      )
    }
  }
}
