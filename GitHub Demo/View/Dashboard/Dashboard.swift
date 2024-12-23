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
    
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Dashboard")
            }
            .navigationTitle("Repositories")
            .onAppear {
                
            }
        }
    }
}

struct DashboardVC_Previews: PreviewProvider {
    static var previews: some View {
        DashboardVC()
    }
}
