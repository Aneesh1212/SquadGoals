//
//  TargetEntry.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/22/21.
//

import Foundation
import SwiftUI

struct TargetEntry: View {
    
    @State var user : User
    @StateObject var viewModel : GoalViewModel
    @State var goalTargetMap : Dictionary<Goal, Array<Target>> = [:]
    @State var submitClicked : Bool
    
    var body: some View {
        VStack(spacing: 24) {
            ForEach(self.viewModel.user.goals, id: \.self) { goal in
                SundaySingleGoal(goal: goal, goalTargetMap: $goalTargetMap, viewModel: self.viewModel, submitClicked: self.submitClicked)
            }
        }
        .task {
            await self.viewModel.getGoals(phoneNumber: user.phoneNumber, isSundayPlanning: true)
        }
        
    }
}
