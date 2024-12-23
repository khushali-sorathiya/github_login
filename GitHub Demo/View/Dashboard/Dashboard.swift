//
//  Dashboard.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//

import Foundation
import SwiftUI
import NavigationStack

struct DashboardVC: View {
    
    let accessToken: String
    @StateObject private var viewModel = RepositoryViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                HStack(alignment: .top) {
                    List {
                        ForEach(viewModel.repositories) { repo in
                            VStack(alignment: .leading) {
                                Text(repo.name)
                                    .font(.headline)
                                Text(repo.description ?? "No description")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                HStack {
                                    Text("Stars: \(repo.stargazersCount)")
                                    Text("Forks: \(repo.forksCount)")
                                }
                                Text("Last update: \(repo.lastupdate)")
                                    .font(.footnote)
//                                    .onAppear {
//                                        if repo == viewModel.repositories.last && !viewModel.isLastPage {
//                                            viewModel.fetchRepositories(isLoadingMore: true)
//                                        }
//                                    }
                            }
                            .padding(.vertical, 4)
                            
                        }
                        if viewModel.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }.padding(.top, -10)
                }
            }
            .navigationTitle("Repositories")
            .onAppear {
                viewModel.fetchRepositories()
            }
        }
    }
}

struct DashboardVC_Previews: PreviewProvider {
    static var previews: some View {
        DashboardVC(accessToken: "")
    }
}
