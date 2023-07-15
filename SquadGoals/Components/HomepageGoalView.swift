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
                    Subtitle(text: self.goal.title, weight: .medium, size: 18)
                    Spacer()
                    Subtitle(text: "🔥\(String(goal.momentumScore))")
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 6)
                .padding(.bottom, 6)
                
                if (self.goal.currTargets.count == 0) {
                    WhiteCard(verticalPadding: Styling.extraSmallUnit) {
                        Subtitle(text:"No tasks this week")
                    }
                    .padding(.vertical, Styling.extraSmallUnit)
                    .shadow(color: .gray, radius: 1, x: 0.0, y: 1.0)
                }
                
                ForEach(self.goal.currTargets, id: \.self) { target in
                    let finished : Int = target.original - target.frequency
                    let unfinished : Int = target.frequency
                    
                    ForEach(0..<unfinished, id: \.self) { _ in
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
                    
                    ForEach(0..<finished, id: \.self) { _ in
                        WhiteCard(verticalPadding: Styling.extraSmallUnit) {
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
                        .shadow(color: .gray, radius: 1, x: 0.0, y: 1.0)
                    }
                }
            }
        }
    }
    
    func mainThing(target : Target) {
        withAnimation {
            let newFrequency = target.frequency - 1
            let targetIndex = goal.currTargets.firstIndex { $0.key == target.key } ?? 10
            self.goal.currTargets[targetIndex].frequency = newFrequency
            viewModel.incrementTarget(goalId: goal.key, targetId: target.key, targetTitle: target.title, targetFrequency: newFrequency, targetOriginal: target.original, creationDate : target.creationDate)
        }
        crossedTaskOffMomentum()
        viewModel.sendUpdateNotification(targetTitle: target.title, goalMomentum: goal.momentumScore)
        viewModel.writeResults()
        UINotificationFeedbackGenerator().notificationOccurred(.success)
    }
    
    func crossedTaskOffMomentum() {
        if (!self.goal.crossedOff) {
            goal.momentumScore = goal.momentumScore + goal.positiveMomentum
            goal.positiveMomentum = goal.positiveMomentum + 1
            goal.negativeMomentum = -1
            goal.recordMomentum = max(goal.recordMomentum, goal.momentumScore)
            goal.crossedOff = true
            viewModel.updateGoalMomentum(goal: goal)
        }
    }
}


