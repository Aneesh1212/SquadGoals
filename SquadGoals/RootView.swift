//
//  RootView.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 2/12/23.
//

import Foundation
import SwiftUI

struct RootView: View {
    @EnvironmentObject var userSession : UserSession
    
    init(user: User) {
        _goalViewModel = StateObject<GoalViewModel>(wrappedValue: GoalViewModel(user: user))
        _loginViewModel = StateObject<LoginViewModel>(wrappedValue: LoginViewModel(currentUser: user, goalViewModel: GoalViewModel(user: user)))
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
