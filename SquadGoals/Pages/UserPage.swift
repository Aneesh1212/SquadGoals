//
//  ProfilePage.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct UserPage: View {
    
    @State var user : User
    @State var selectedGoal : Goal = Goal(title: "", reason: "", category: "", currTargets: [], momentumScore: 0, positiveMomentum: 0, negativeMomentum: 0, recordMomentum: 0, crossedOff: false)
    @State var shouldNavigateToGoalDetails = false

    var viewModel = GoalViewModel(user: User(name: "", phoneNumber: "", groupId: "", goals: [], teammates: []))
    
    var body: some View {
        VStack{
            Title(text:user.name, size: 48)
            
            let totalTargets = viewModel.calculateTotalTargets(goals: user.goals)
            let completedTargets = viewModel.calculateCompletedTargets(goals: user.goals)
            
            Text("\(String(completedTargets)) / \(String(totalTargets)) weekly tasks completed")
                .multilineTextAlignment(.leading)
                .font(.system(size: 18).italic())
                .padding(.top, 2)
                .padding(.bottom, 22)
                .foregroundColor(Colors.blueText)
            
            ScrollView(showsIndicators: false){
                ForEach(user.goals, id: \.self) { goal in
                    HomepageGoalView(goal: goal, viewModel: self.viewModel, clickableTargets: false)
                        .padding(.bottom, 20)
                }
            }
            
            HStack{
                Spacer()
            }
        }
        .padding(.horizontal, 25)
        .background(Colors.background)
    }
}
