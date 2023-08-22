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
    @State var selectedGoal : Goal = Goal(title: "", reason: "", category: "", currTargets: [], momentumScore: 0, positiveMomentum: 0, negativeMomentum: 0, recordMomentum: 0, crossedOff: false, key: ".")
    @State var shouldNavigateToGoalDetails = false
    @State var shouldNavigateToWelcome = false
    @State var bottomSheetOpen = false
    @State var navigateToCreateGoal = false
    
    
    var body: some View {
        VStack{
            HStack() {
                Spacer()
                PillActionButton(text: "Sign Out", icon: "rectangle.portrait.and.arrow.right", foregroundColor: .black, backgroundColor: Colors.buttonSignOut, action: {
                    self.shouldNavigateToWelcome = true
                })
            }
            
            Title(text: viewModel.user.name, size: 48)
            Subtitle(text: "Team #\(viewModel.user.groupId)")
                .padding(.bottom, Styling.mediumUnit)
            
            Text("[Learn How Momentum🔥Works](https://nagrawal44.wixsite.com/squad-goals/general-9)")
                .underline()
                .foregroundColor(.black)
                .tint(.black)
                .font(.system(size:  16, weight: .regular))
                .padding(.bottom, Styling.mediumUnit)
                        
            ScrollView {
                ForEach(viewModel.user.goals, id: \.self) { goal in
                    WhiteActionButtonWithArrow(text: goal.title, action: {
                        self.selectedGoal = goal
                        self.shouldNavigateToGoalDetails = true
                    })
                    
                    Spacing(height: 24)
                }
          }
            
            Filler()
            
            GreenActionButton(text: "+ Add Goal", action: {
                self.navigateToCreateGoal = true
            })
            
            VStack {
                NavigationLink(destination: GoalDetailPage(goal: self.selectedGoal, viewModel: self.viewModel), isActive: $shouldNavigateToGoalDetails) { EmptyView() }
                NavigationLink(destination: Welcome(shouldTryToSignIn: false), isActive: $shouldNavigateToWelcome) { EmptyView() }
                NavigationLink(destination: CreateGoal(viewModel: self.viewModel, isSingleGoal: true), isActive: $navigateToCreateGoal) { EmptyView() }
            }
        }
        .padding(.horizontal, 25)
        .padding(.bottom, 25)
        .background(Colors.background)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
