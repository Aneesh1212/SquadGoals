//
//  RootView.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 2/12/23.
//

import Foundation
import SwiftUI

struct RootView: View {
    @StateObject var goalViewModel: GoalViewModel
    @StateObject var loginViewModel : LoginViewModel
    
    init(user: User) {
        _goalViewModel = StateObject<GoalViewModel>(wrappedValue: GoalViewModel(user: user))
        _loginViewModel = StateObject<LoginViewModel>(wrappedValue: LoginViewModel(currentUser: user))
    }
    
    var body: some View {
        NavigationView{
            Welcome(shouldTryToSignIn: true)
                .navigationBarTitle("")
                .navigationBarHidden(true)
        }
        .environmentObject(goalViewModel)
        .environmentObject(loginViewModel)
    }
}
