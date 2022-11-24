import Foundation
import XCTestDynamicOverlay
import ComposableArchitecture

struct RepoSearchClient {
  var search: @Sendable (String) async throws -> RepositoryModel
}

extension DependencyValues {
  var repoSearchClient: RepoSearchClient {
    get { self[RepoSearchClient.self] }
    set { self[RepoSearchClient.self] = newValue }
  }
}

// MARK: - Live API implementation

extension RepoSearchClient: DependencyKey {
  static let liveValue = RepoSearchClient(
    search: { keyword in
      guard let url = URL(string: "https://api.github.com/search/repositories?q=\(keyword)") else {
        throw APIError.invalidUrlError
      }
      let (data, _) = try await URLSession.shared.data(from: url)
      return try JSONDecoder().decode(RepositoryModel.self, from: data)
    }
  )
}

extension RepoSearchClient: TestDependencyKey {
  static let previewValue = Self(
    search: { _ in .mock }
  )

  static let testValue = Self(
    search: unimplemented("\(Self.self).search")
  )
}
