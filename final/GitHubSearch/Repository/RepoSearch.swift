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
    case searchButtonTapped
    case dataLoaded(TaskResult<RepositoryModel>)
  }

  @Dependency(\.repoSearchClient) var repoSearchClient
  
  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
     switch action {
     case let .keywordChanged(keyword):
       state.keyword = keyword
       return .none

     case .searchButtonTapped:
       state.isLoading = true

       return .run { [keyword = state.keyword] send in
         let result = await TaskResult { try await repoSearchClient.search(keyword) }
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
    }
  }
}
