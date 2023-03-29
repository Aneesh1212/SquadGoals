//
//  ProfilePage.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct ProfilePage: View {
    
    @StateObject var viewModel : GoalViewModel
    @State var selectedGoal : Goal = Goal(title: "", reason: "", category: "", isPrivate: false, currTargets: [])
    @State var shouldNavigateToGoalDetails = false
    @State var shouldNavigateToWelcome = false
    @State var bottomSheetOpen = false
    @State var navigateToCreateGoal = false
    
    
    var body: some View {
        VStack{
            HStack() {
                Spacer()
                PillActionButton(text: "Sign out", foregroundColor: Colors.darkOrangeForeground, backgroundColor: Colors.opaqueOrangeBackground, action: {
                    self.shouldNavigateToWelcome = true
                })
            }
            
            Title(text: viewModel.user.name, size: 48)
            Subtitle(text: "Team #\(viewModel.user.groupId)")
                .padding(.bottom, Styling.largeUnit)
                        
            ScrollView {
                ForEach(viewModel.user.goals, id: \.self) { goal in
                    WhiteActionButton(text: goal.title, action: {
                        self.selectedGoal = goal
                        self.shouldNavigateToGoalDetails = true
                    })
                    
                    Spacing(height: 36)
                }
            }
            
            Filler()
            
            GreenActionButton(text: "+ Add Goal", action: {
                self.navigateToCreateGoal = true
            })
            
            VStack {
                NavigationLink(destination: GoalDetailPage(goal: self.selectedGoal, viewModel: self.viewModel), isActive: $shouldNavigateToGoalDetails) { EmptyView() }
                NavigationLink(destination: Welcome(shouldTryToSignIn: false), isActive: $shouldNavigateToWelcome) { EmptyView() }
                NavigationLink(destination: CreateGoal(user: self.viewModel.user, isSingleGoal: true), isActive: $navigateToCreateGoal) { EmptyView() }
            }
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 25)
        .background(Colors.lightOrangeBackground)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
