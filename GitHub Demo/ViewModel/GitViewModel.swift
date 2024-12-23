//
//  GithubViewModel.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//

import Foundation
import ProgressHUD


//let githubVM = GithubViewModel()

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
                            //udf.setObject(value: accessToken, key: .accessToken)
                        }
                    } else {
                        print("Failed to fetch access token from response: \(parsedResponse)")
                    }
                    
                case let .failure(error):
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
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var currentPage = 1
    private var limit = 3
    @Published var isLastPage = false
    
    
    func fetchRepositories(isLoadingMore: Bool = false) {
        guard !isLoading, !isLastPage else { return }
        
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
                            self.currentPage += 1
                            if repos.count < self.limit {
                                self.isLastPage = true
                            }
                        }
                    } else {
                        print("Failed to decode repositories")
                        self.isLastPage = true
                    }
                    
                case let .failure(error):
                    print(error.localizedDescription)
                    self.isLastPage = true
                }
            }
        }else{
            print(StringMsg.noInternet.rawValue)
        }
    }
    
    func resetPagination() {
        currentPage = 1
        isLastPage = false
        repositories = []
        fetchRepositories()
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



