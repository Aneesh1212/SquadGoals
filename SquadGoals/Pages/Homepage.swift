//
//  Homepage.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/21/21.
//

import Foundation
import SwiftUI

struct Homepage : View {
    
    @StateObject var viewModel : GoalViewModel
    @State var targetProgressValue: Float = 0.0
    var showReflectionPrompt : Bool
    @State var shouldNavigateToEditGoals : Bool = false
    @State var shouldNavigateToAddGoal : Bool = false
    
    var openTargets : some View {
        VStack {
            LightBlueCard{
                HStack(spacing: 0) {
                    Label ("", systemImage: "list.bullet.clipboard")
                        .foregroundColor(.black)
                    Subtitle(text: "\(String(viewModel.completedTargets)) / \(String(viewModel.totalTargets)) Weekly Tasks Completed", size: 16)
                }
            }
            
            ScrollView(showsIndicators: false){
                ForEach(viewModel.user.goals, id: \.self) { goal in
                    HomepageGoalView(goal: goal, viewModel: self.viewModel, clickableTargets: !showReflectionPrompt)
                        .padding(.bottom, 20)
                }
            }
            HStack{
                Spacer()
            }
        }
        .background(Colors.background)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack{
                Title(text: "Hi, \(viewModel.user.name)", size: 20)
                Spacer()
                PillActionButton(text: "Edit tasks", icon: "pencil",foregroundColor: .black, backgroundColor: Colors.buttonSignOut, action: {
                    self.shouldNavigateToEditGoals = true
                })
            }
            OrangeCard {
                LeftAligner (content: AnyView(
                    VStack(alignment: .leading) {
                        TitleV2(text: "Week \(viewModel.week + 1)")
                        SubtitleV2(text: "\(UtilFunctions.getDaysLeftInCycle()) days remaining in cycle")
                    }
                )
                )
                
                Race(viewModel: self.viewModel)
                    .frame(alignment: .leading)
            }
            
            if (!viewModel.user.goals.contains(where: { $0.title != "" })) {
                //EmptyState()
                SampleGoal(navigateToAddGoal: $shouldNavigateToAddGoal)
            } else {
                openTargets
            }
            
            if (viewModel.user.teammates.count == 0) {
                Spacing(height: Styling.smallUnit)
                InviteFriendsComponent(groupId: viewModel.user.groupId)
            }
            
            NavigationLink(destination: MondayPlanning(viewModel: self.viewModel, mode: Mode.editing), isActive: $shouldNavigateToEditGoals) { EmptyView() }
            NavigationLink(destination: CreateGoal(viewModel: self.viewModel, isSingleGoal: false), isActive: $shouldNavigateToAddGoal) { EmptyView() }
            
            Spacer()
        }
        .padding(.horizontal, 25)
        .background(Colors.background)
        .navigationBarHidden(true)
    }
}
