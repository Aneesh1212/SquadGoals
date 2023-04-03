//
//  HomepageGoalView.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/21/21.
//

import Foundation
import SwiftUI

struct HomepageGoalView : View {
    
    @State var goal : Goal
    @State var viewModel : GoalViewModel
    var clickableTargets: Bool
    
    var body : some View {
        
        WhiteCard {
            VStack(spacing: 0) {
                HStack{
                    Subtitle(text: self.goal.title, size: 18)
                    Spacer()
                    Subtitle(text: "🔥12")
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(6)
                
                ForEach(self.goal.currTargets, id: \.self) { target in
                    let finished : Int = target.original - target.frequency
                    let unfinished : Int = target.frequency
                    
                    ForEach(0..<unfinished) { _ in
                        WhiteCard(verticalPadding: Styling.extraSmallUnit) {
                            HStack(){
                                Button(action: {
                                    mainThing(target: target)
                                },
                                       label: { Image(systemName: "circle")
                                        .clipShape(Circle())
                                        .shadow(radius: 20)
                                        .foregroundColor(Color.green)
                                })
                                    .disabled(!clickableTargets)
                                Text(target.title)
                                Spacer()
                            }
                        }
                        .padding(.vertical, 6)
                        .fixedSize(horizontal: false, vertical: true)
                        .shadow(color: .gray, radius: 1, x: 0.0, y: 1.0)
                    }
                    
                    ForEach(0..<finished) { _ in
                        WhiteCard(verticalPadding: Styling.smallUnit) {
                            HStack{
                                Image(systemName: "checkmark")
                                    .resizable()
                                    .padding(6)
                                    .frame(width: 20, height: 20)
                                    .background(Color.green)
                                    .clipShape(Circle())
                                    .foregroundColor(.white)
                                    .opacity(0.6)
                                Text(target.title)
                                    .opacity(0.6)
                                Spacer()
                            }
                        }
                        .padding(.vertical, 6)
                        .fixedSize(horizontal: false, vertical: true)
                        .shadow(color: .gray, radius: 3, x: 0.0, y: 5.0)
                    }
                }
            }
        }
    }
    
    func mainThing(target : Target) {
        withAnimation {
            let newFrequency = target.frequency - 1
            let targetIndex = self.goal.currTargets.firstIndex(of: target) ?? 0
            let goalIndex = viewModel.user.goals.firstIndex(of: self.goal) ?? 0
            self.goal.currTargets[targetIndex].frequency = newFrequency
            viewModel.overwriteTarget(goalId: goal.key ?? "", targetId: target.key ?? "", targetTitle: target.title, targetFrequency: newFrequency, targetOriginal: target.original, creationDate : target.creationDate)
            viewModel.user.goals[goalIndex] = self.goal
            viewModel.completedTargets += 1
        }
        viewModel.sendUpdateNotification(targetTitle: target.title)
        viewModel.writeResults()
    }
}


