import ComposableArchitecture

struct RepositorySearch: ReducerProtocol {
  struct State: Equatable {
    var keyword = ""
    var searchResults = [String]()
  }

  enum Action: Equatable {
    case keywordChanged(String)
    case searchButtonTapped
  }

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
     switch action {
     case let .keywordChanged(keyword):
       state.keyword = keyword
       return .none

     case .searchButtonTapped:
       state.searchResults = sampleRepoLists.filter {
         $0.contains(state.keyword)
       }
       return .none
    }
  }

  private let sampleRepoLists = [
    "Swift",
    "SwiftyJSON",
    "SwiftGuide",
    "SwiftterSwift",
  ]
}
