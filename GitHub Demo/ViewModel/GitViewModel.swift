//
//  GithubViewModel.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//

import Foundation
import ProgressHUD


let githubVM = GithubViewModel()

//MARK: Api View Model
class GithubViewModel {
    
    func showLoader() {
        ProgressHUD.marginSize = 20
        ProgressHUD.mediaSize = 50
        ProgressHUD.colorAnimation = .black
    }
    
    func hideLoader() {
        ProgressHUD.dismiss()
    }
    
    func apiLogin(param: [String:Any], onSuccess: @escaping(UserDataModel) -> Void, onFailuer: @escaping(String) -> Void) {
        if Reachability.isConnectedToNetwork() {
            showLoader()
            nm.kgProvider.request(.login(param: param)){ result in
                self.hideLoader()
                switch result {
                case let .success(response):
                    
                    if let info = try? JSONDecoder().decode(UserDataModel.self, from: response.data) {
                        onSuccess(info)
                    }else{
                        onFailuer("")
                    }
                case let .failure(error):
                    onFailuer(error.localizedDescription)
                }
            }
        }else{
            onFailuer(StringMsg.noInternet.rawValue)
        }
    }
    
    
    
    
}



