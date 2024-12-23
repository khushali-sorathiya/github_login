//
//  login.swift
//  GitHub Demo
//
//  Created by khushali on 23/12/24.
//


import Foundation
import SwiftUI
import NavigationStack
import SafariServices

struct LoginVC: View {
    
    //MARK: Body
    var body: some View {
        ZStack {
            VStack {
                        Spacer()
                        Button(action: {
                            loginWithGitHub()
                        }) {
                            HStack(spacing: 10) {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                Text("Login with GitHub")
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.black)
                            .cornerRadius(8)
                        }
                        .padding(.horizontal, 16)
                        Spacer()
                    }
        }.onAppear(perform: viewDidLoad)
            .edgesIgnoringSafeArea(.bottom)
    }
    
    func viewDidLoad() {
        
    }
    
    func loginWithGitHub() {
        guard let url = URL(string: "\(AppConfig.baseUrl)\(AppConfig.authorizationURL)?client_id=\(AppConfig.clientID)&redirect_uri=\(AppConfig.redirectURI)&scope=\(AppConfig.scope)") else {
                return
            }
            UIApplication.shared.open(url)
    }
   
}

struct LoginVC_Previews: PreviewProvider {
    static var previews: some View {
        LoginVC()
    }
}
