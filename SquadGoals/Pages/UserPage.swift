//
//  ProfilePage.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct UserPage: View {
    
    @State var teammate : User
    @State var shouldNavigateToGoalDetails = false
    
    var body: some View {
        VStack{
            Title(text:teammate.name, size: 48, scaleFactor: 0.5)
            
            let totalTargets = UtilFunctions.calculateTotalTargets(goals: teammate.goals)
            let completedTargets = UtilFunctions.calculateCompletedTargets(goals: teammate.goals)
            
            Subtitle(text:"\(String(completedTargets)) / \(String(totalTargets)) weekly tasks completed", size: 16)
                .padding(.top, 1)
                .padding(.bottom, 22)
            
            ScrollView(showsIndicators: false){
                ForEach(teammate.goals, id: \.self) { goal in
                    HomepageGoalView(goal: goal, viewModel: GoalViewModel(), clickableTargets: false)
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
