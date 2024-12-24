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
    @EnvironmentObject var authManager: GitHubAuthManager
    @State private var search: String = ""
    
    @State private var filteredRepo : [Repository] = []
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                VStack(alignment: .leading) {
                        HStack {
                            Text("Repositories")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                            Button(action: {
                                viewModel.unAuthorized = true
                                authManager.accessToken = nil
                                authManager.isAuthenticated = false
                            }) {
                                Image(systemName: "rectangle.portrait.and.arrow.forward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.black)
                            }
                            
                        }
                        .padding(.horizontal)
                        .padding(.top, 20)
                        .padding(.bottom, 10)
                        
                        HStack {
                            TextField("Search...", text: $search)
                                .padding(10)
                                .padding(.horizontal, 24)
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                                .overlay(
                                    HStack {
                                        Image(systemName: "magnifyingglass")
                                            .foregroundColor(.gray)
                                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                                            .padding(.leading, 8)
                                        
                                        if !search.isEmpty {
                                            Button(action: {
                                                search = ""
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.gray)
                                                    .padding(.trailing, 8)
                                            }
                                        }
                                    }
                                )
                        }.onChange(of: search, {
                            filterList()
                        })
                        .padding(.horizontal)
                        .padding(.bottom,10)
                        List {
                            ForEach(filteredRepo.indices, id: \.self) { index in
                                let repo = filteredRepo[index]
                                VStack(alignment: .leading,spacing:2) {
                                    HStack(alignment: .top) {
                                        VStack(alignment: .leading) {
                                            Text(repo.name)
                                                .font(.headline)
                                            let date = repo.lastupdate.formatDate(date: repo.lastupdate, dateFormate: "yyyy-MM-dd'T'HH:mm:ssZ", formate: "dd MMM yyyy")
                                            Text("update on: \(date)")
                                                .font(.footnote)
                                        }
                                        Spacer()
                                        VStack(alignment: .trailing,spacing: 5) {
                                            HStack(alignment:.center,spacing:8) {
                                                Image("star")
                                                    .resizable()
                                                    .foregroundColor(.gray)
                                                    .frame(width: 13, height: 13)
                                                HStack(spacing:1) {
                                                    Text("\(repo.stargazersCount)")
                                                        .fontWeight(.medium)
                                                    Text("star")
                                                        .font(.system(size: 15))
                                                }
                                            }//tuningfork
                                            HStack(alignment:.center,spacing:8) {
                                                Image("code-fork")
                                                    .resizable()
                                                    .frame(width: 13, height: 13)
                                                    .foregroundColor(.gray)
                                                HStack(spacing:1) {
                                                    Text("\(repo.forksCount)")
                                                        .fontWeight(.medium)
                                                    Text("forks")
                                                        .font(.system(size: 15))
                                                }
                                            }
                                        }
                                    }
                                    
                                    Text(repo.description ?? "No Description")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                       
                                }.onAppear {
                                        if index == filteredRepo.count - 1 {
                                            if !viewModel.isLoading && viewModel.loadMore {
                                                    viewModel.fetchRepositories(isLoadingMore: true)
                                                }
                                            }
                                        }
                            }
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }.padding(.top, -10)
                }.background(Color(.blue.withAlphaComponent(0.2)))
                .navigationDestination(isPresented: $viewModel.unAuthorized) {
                    LoginVC()
                }
                .onChange(of: viewModel.repositories.count, {
                    filteredRepo = viewModel.repositories
                })
                .onAppear {
                    viewModel.fetchRepositories()
                }
                .padding(.top,30)
                .edgesIgnoringSafeArea(.top)
            }
        }
    }
    
    
    func filterList() {
        if search.isEmpty {
            filteredRepo = viewModel.repositories
            } else {
                filteredRepo = viewModel.repositories.filter { $0.name.lowercased().contains(search.lowercased()) }
            }
        }
}

struct DashboardVC_Previews: PreviewProvider {
    static var previews: some View {
        DashboardVC(accessToken: "")
    }
}
