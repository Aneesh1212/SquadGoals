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
    @State var selectedGoal : Goal = Goal(title: "", reason: "", category: "", isPrivate: false, currTargets: [])
    @State var shouldNavigateToGoalDetails = false
    @EnvironmentObject var viewModel : GoalViewModel
    
    var body: some View {
        VStack{
            Text(user.name)
                .multilineTextAlignment(.center)
                .font(.system(size: 40, weight: .heavy))
                .frame(width: .infinity, height: 80)
                .frame(maxWidth: .infinity)
                .foregroundColor(Colors.lightOrangeBackground)
                .background(Colors.darkOrangeForeground)
            
            let totalTargets = viewModel.calculateTotalTargets(goals: user.goals)
            let completedTargets = viewModel.calculateCompletedTargets(goals: user.goals)
            
            Text("\(String(completedTargets)) / \(String(totalTargets)) weekly tasks completed")
                .multilineTextAlignment(.leading)
                .font(.system(size: 18).italic())
                .padding(.top, 10)
                .padding(.bottom, 22)
                .foregroundColor(Colors.blueText)
            
            ScrollView(showsIndicators: false){
                ForEach(user.goals, id: \.self) { goal in
                    HomepageGoalView(goal: goal, clickableTargets: false)
                        .padding(.bottom, 20)
                }
            }
            
            HStack{
                Spacer()
            }
        }
        .background(Colors.lightOrangeBackground)
    }
}
