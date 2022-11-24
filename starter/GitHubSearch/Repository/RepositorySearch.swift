import ComposableArchitecture
import Foundation

struct RepositorySearch: ReducerProtocol {
  struct State: Equatable {
    // TODO: 지금 앱은 어떤 상태들로 정의되는가?
  }

  enum Action: Equatable {
    // TODO: 상태들을 변화시키는 사용자의 액션은 무엇인가?
  }

  func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
    // TODO: 각각의 Action이 발생했을 때 상태는 어떻게 변화해야 하는가?
  }
}
