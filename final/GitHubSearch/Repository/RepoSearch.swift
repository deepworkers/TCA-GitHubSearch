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

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
     switch action {
     case let .keywordChanged(keyword):
       state.keyword = keyword
       return .none

     case .searchButtonTapped:
       state.isLoading = true

       return Effect.run { [keyword = state.keyword] send in
         guard let url = URL(string: "https://api.github.com/search/repositories?q=\(keyword)") else {
           throw APIError.invalidUrlError
         }

         let (data, _) = try await URLSession.shared.data(from: url)
         let result = await TaskResult { try JSONDecoder().decode(RepositoryModel.self, from: data) }

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
