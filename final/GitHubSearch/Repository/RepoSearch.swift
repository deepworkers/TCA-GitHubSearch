import Foundation

import ComposableArchitecture

struct RepoSearch: ReducerProtocol {
  struct State: Equatable {
    var keyword = ""
    var searchResults = [RepositoryModel.Result]()
    var isLoading = false
  }

  enum Action: Equatable {
    case keywordChanged(String)
    case requestRepoSearch
    case cancelRepoSearch
    case dataLoaded(TaskResult<RepositoryModel>)
  }

  @Dependency(\.repoSearchClient) var repoSearchClient
  @Dependency(\.continuousClock) var clock

  enum RepoSearchRequestDebounceId {}

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
     switch action {
     case let .keywordChanged(keyword):
       state.keyword = keyword

       if keyword == "" {
         return .run { send in
           await send(.cancelRepoSearch)
         }
       }

       return .run { send in
         try await self.clock.sleep(for: .seconds(0.5))
         await send(.requestRepoSearch)
       }
       .cancellable(id: RepoSearchRequestDebounceId.self, cancelInFlight: true)

     case .requestRepoSearch:
       state.isLoading = true
       return .run { [keyword = state.keyword] send in
         let result = await TaskResult { try await self.repoSearchClient.search(keyword) }
         await send(.dataLoaded(result))
       }
     case let .dataLoaded(.success(repositoryModel)):
       state.isLoading = false
       state.searchResults = repositoryModel.items
       return .none

     case .dataLoaded(.failure):
       state.isLoading = false
       state.searchResults = []
       return .none

     case .cancelRepoSearch:
       state.searchResults = []
       state.isLoading = false
       return .cancel(id: RepoSearchRequestDebounceId.self)
     }
  }
}
