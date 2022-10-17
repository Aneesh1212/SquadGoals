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
        VStack{
            Text("\(String(viewModel.completedTargets)) / \(String(viewModel.totalTargets)) weekly targets completed")
                .multilineTextAlignment(.leading)
                .font(.system(size: 18).italic())
                .padding(.top, 10)
                .padding(.bottom, 22)
                .foregroundColor(Colors.blueText)
                
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
            VStack(alignment: .leading) {
                Button(action: {
                    self.shouldNavigateToEditGoals = true
                }, label: {
                    Text("Edit")
                        .font(.system(size:16, weight: .heavy))
                        .foregroundColor(Colors.lightOrangeBackground)
                        .padding(.leading, 300)
                })
                
                Text("WEEK \(viewModel.week + 1)")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 30, weight: .heavy))
                    .foregroundColor(Colors.lightOrangeBackground)
                
                Text("LETS PUSH FORWARD")
                    .multilineTextAlignment(.leading)
                    .font(.system(size: 22))
                    .foregroundColor(Colors.lightOrangeBackground)
                
                Race(viewModel: self.viewModel)
                    .frame(alignment: .leading)
                    .padding(.bottom, 18)
            }
            .padding(.horizontal, 25)
            .background(Colors.darkOrangeForeground)
            
            if (viewModel.completedTargets >= viewModel.totalTargets) {
                Completion(viewModel: self.viewModel)
            } else {
                openTargets
            }
        
            NavigationLink(destination: SundayPlanning(user: self.viewModel.user, viewModel: self.viewModel, mode: Mode.editing), isActive: $shouldNavigateToEditGoals) { EmptyView() }
            
            Spacer()
        }
        .background(Colors.lightOrangeBackground)
        .navigationBarHidden(true)
    }
}
