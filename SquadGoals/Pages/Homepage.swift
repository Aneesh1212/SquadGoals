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
    
    var openTargets : some View {
        VStack {
            BlueCard{
                HStack(spacing: 0) {
                    Label ("", systemImage: "doc.plaintext")
                        .foregroundColor(.white)
                    TitleV2(text: "\(String(viewModel.completedTargets)) / \(String(viewModel.totalTargets)) Weekly Tasks Completed", size: 16)
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
        .background(Colors.lightOrangeBackground)
    }
    
    var body: some View {
        VStack{
            OrangeCard {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        TitleV2(text: "Week \(viewModel.week + 1)")
                        SubtitleV2(text: "X days remaining in cycle")
                    }
                    PillActionButton(text: "Edit tasks", icon: "pencil",foregroundColor: .white, backgroundColor: Colors.opaqueWhite, action: {
                            self.shouldNavigateToEditGoals = true
                    })
                }
                
                Race(viewModel: self.viewModel)
                    .frame(alignment: .leading)
            }
            
            if (viewModel.completedTargets >= viewModel.totalTargets) {
                Completion(viewModel: self.viewModel)
            } else {
                openTargets
            }
        
            NavigationLink(destination: MondayPlanning(user: self.viewModel.user, viewModel: self.viewModel, mode: Mode.editing), isActive: $shouldNavigateToEditGoals) { EmptyView() }
            
            Spacer()
        }
        .padding(.horizontal, 25)
        .background(Colors.lightOrangeBackground)
        .navigationBarHidden(true)
    }
}
