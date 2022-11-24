import SwiftUI

struct RepositorySearchView: View {
  @State private var searchKeyword = ""
  @State private var searchResults: [String] = []

  private let sampleRepoLists = [
    "Swarm",
    "Swim",
    "Switch",
    "Swing",
    "Swift",
    "SwiftyJSON",
    "SwiftGuide",
    "SwiftterSwift",
  ]

  var body: some View {
    NavigationView {
      VStack {
        HStack {
          TextField("Search repo", text: self.$searchKeyword)
            .textFieldStyle(.roundedBorder)

          Button("Search") {
            self.searchResults = self.sampleRepoLists.filter {
              $0.contains(self.searchKeyword)
            }
          }
          .buttonStyle(.borderedProminent)
        }
        .padding()

        List {
          ForEach(self.searchResults, id: \.self) { Text($0) }
        }
      }
      .navigationTitle("Github Search")
    }
  }
}

struct RepoSearchView_Previews: PreviewProvider {
  static var previews: some View {
    RepositorySearchView()
  }
}
