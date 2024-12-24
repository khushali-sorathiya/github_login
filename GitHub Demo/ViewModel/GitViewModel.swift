//
//  GithubViewModel.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//

import Foundation
import ProgressHUD
import CoreData

func showLoader() {
    ProgressHUD.marginSize = 20
    ProgressHUD.mediaSize = 50
    ProgressHUD.colorAnimation = .black
}

func hideLoader() {
    ProgressHUD.dismiss()
}

class GitHubAuthManager: ObservableObject {
    
    static let shared = GitHubAuthManager()
    
    @Published var accessToken: String? {
        didSet {
            isAuthenticated = accessToken != nil
        }
    }
    
    @Published var isAuthenticated = false
    
    func handleCallback(url: URL) {
        guard let code = url.queryParameters?["code"] else {
            print("Authorization code not found")
            return
        }
        fetchAccessToken(code: code)
    }
    
    private func fetchAccessToken(code: String) {
        
        let param: [String: Any] = [
            "client_id": AppConfig.clientID,
            "client_secret": AppConfig.clientSecret,
            "code": code,
            "redirect_uri": AppConfig.redirectURI
        ]
        
        if Reachability.isConnectedToNetwork() {
            showLoader()
            nm.kgProvider.request(.login(param: param)){ result in
                hideLoader()
                switch result {
                case let .success(response):
                    
                    guard let responseString = String(data: response.data, encoding: .utf8) else {
                        print("No data received or data is not valid UTF-8")
                        return
                    }
                    let parsedResponse = self.parseURLEncodedResponse(responseString)
                    
                    if let accessToken = parsedResponse["access_token"] {
                        DispatchQueue.main.async {
                            self.accessToken = accessToken
                            udf.setObject(value: accessToken, key: .accessToken)
                        }
                    } else {
                        print("Failed to fetch access token from response: \(parsedResponse)")
                    }
                    
                case .failure(_):
                    print(StringMsg.wrong)
                }
            }
        }else{
            print(StringMsg.noInternet.rawValue)
        }
   }
    
    func parseURLEncodedResponse(_ response: String) -> [String: String] {
        var result = [String: String]()
        let pairs = response.split(separator: "&")
        for pair in pairs {
            let components = pair.split(separator: "=", maxSplits: 1)
            if components.count == 2 {
                let key = String(components[0]).removingPercentEncoding ?? String(components[0])
                let value = String(components[1]).removingPercentEncoding ?? String(components[1])
                result[key] = value
            }
        }
        return result
    }
}

class RepositoryViewModel: ObservableObject {
    @Published var repositories: [Repository] = []
    @Published var unAuthorized : Bool = false
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var currentPage = 1
    private var limit = 3
    @Published var loadMore = true
    
    @Published var isOffline: Bool = false
    private let persistenceController = PersistenceController.shared
    
    func fetchRepositories(isLoadingMore: Bool = false) {
        guard !isLoading, loadMore else { return }
        
        isLoading = true
        if Reachability.isConnectedToNetwork() {
            showLoader()
            
            nm.kgProvider.request(.dashboard(page: currentPage, perPage: limit)){ result in
                hideLoader()
                self.isLoading = false
                switch result {
                case let .success(response):
                    
                    if let repos = try? JSONDecoder().decode([Repository].self, from: response.data) {
                        DispatchQueue.main.async {
                            if isLoadingMore {
                                self.repositories.append(contentsOf: repos)
                            } else {
                                self.repositories = repos
                            }
                            self.saveRepositoriesToCoreData(repos)
                            self.currentPage += 1
                            if repos.count < self.limit {
                                self.loadMore = false
                            }
                        }
                    } else {
                        print("Failed to decode repositories")
                        self.loadMore = false
                        if response.statusCode == 401 {
                            udf.removeAllObject()
                            self.unAuthorized = true
                        }
                        
                    }
                    
                case let .failure(error):
                    print(error.localizedDescription)
                    self.loadMore = false
                }
            }
        }else{
            print(StringMsg.noInternet.rawValue)
            loadRepositoriesFromCoreData()
            isOffline = true
            
        }
    }
    
    func resetPagination() {
        currentPage = 1
        loadMore = true
        repositories = []
        fetchRepositories()
    }
    
    
    private func saveRepositoriesToCoreData(_ repositories: [Repository]) {
        let context = persistenceController.container.viewContext
        
        let fetchRequest: NSFetchRequest<Gitrepo> = Gitrepo.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id IN %@", repositories.map { $0.id })
        
        do {
            let existRepo = try context.fetch(fetchRequest)
            
            let existRepoDict = Dictionary(uniqueKeysWithValues: existRepo.map { ($0.id, $0) })
            
            for repo in repositories {
                if let existrepo = existRepoDict[Int64(repo.id)] {
                    existrepo.name = repo.name
                    existrepo.repoDescription = repo.description
                    existrepo.stargazersCount = Int64(repo.stargazersCount)
                    existrepo.forksCount = Int64(repo.forksCount)
                    existrepo.lastUpdate = repo.lastupdate
                } else {
                    let repositoryEntity = Gitrepo(context: context)
                    repositoryEntity.id = Int64(repo.id)
                    repositoryEntity.name = repo.name
                    repositoryEntity.repoDescription = repo.description
                    repositoryEntity.stargazersCount = Int64(repo.stargazersCount)
                    repositoryEntity.forksCount = Int64(repo.forksCount)
                    repositoryEntity.lastUpdate = repo.lastupdate
                }
            }
            
            try context.save()
            
        } catch {
            print("Failed to load core data: \(error)")
        }
    }
    
    private func loadRepositoriesFromCoreData() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<Gitrepo> = Gitrepo.fetchRequest()
        do {
            let fetchedRepositories = try context.fetch(fetchRequest)
            self.repositories = fetchedRepositories.map { repo in
                Repository(
                    id: Int(repo.id),
                    name: repo.name ?? "",
                    description: repo.repoDescription,
                    stargazersCount: Int(repo.stargazersCount),
                    forksCount: Int(repo.forksCount),
                    lastupdate: repo.lastUpdate ?? ""
                )
            }
        } catch {
            print("Failed to load core data: \(error)")
        }
    }
    
    func clearRepoData() {
        let context = persistenceController.container.viewContext
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = Gitrepo.fetchRequest()
        let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(delete)
            try context.save()
        } catch {
            print("Failed delete: \(error)")
        }
    }
}

extension URL {
    var queryParameters: [String: String]? {
        URLComponents(url: self, resolvingAgainstBaseURL: false)?
            .queryItems?
            .reduce(into: [String: String]()) { result, item in
                result[item.name] = item.value
            }
    }
}



