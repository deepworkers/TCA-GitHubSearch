import SwiftUI

import ComposableArchitecture

struct RepositorySearchView: View {
  let store: StoreOf<RepositorySearch>

  var body: some View {
    WithViewStore(store) { viewStore in
      NavigationView {
        VStack {
          HStack {
            TextField(
              "Search repo",
              text: Binding(
                get: { viewStore.keyword },
                set: { viewStore.send(.keywordChanged($0)) }
              )
            )
            .textFieldStyle(.roundedBorder)

            Button("Search") {
              viewStore.send(.searchButtonTapped)
            }
            .buttonStyle(.borderedProminent)
          }
          .padding()

          List {
            ForEach(viewStore.searchResults, id: \.self) {
              Text($0)
            }
          }
        }
        .navigationTitle("Github Search")
      }
    }
  }
}

struct RepoSearchView_Previews: PreviewProvider {
  static var previews: some View {
    RepositorySearchView(
      store: Store(
        initialState: RepositorySearch.State(),
        reducer: RepositorySearch()
      )
    )
  }
}
