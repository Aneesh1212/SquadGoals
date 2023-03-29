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
                    Subtitle(text: self.goal.title)
                    Spacer()
                    Subtitle(text: "🔥12")
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.bottom, 2)
                
                ForEach(self.goal.currTargets, id: \.self) { target in
                    let finished : Int = target.original - target.frequency
                    let unfinished : Int = target.frequency
                    
                    ForEach(0..<finished) { _ in
                        HStack(){
                            Image(systemName: "checkmark")
                                .resizable()
                                .padding(6)
                                .frame(width: 24, height: 24)
                                .background(Color.green)
                                .clipShape(Circle())
                                .foregroundColor(.white)
                                .opacity(0.6)
                            Text(target.title)
                                .foregroundColor(Colors.blueText)
                                .opacity(0.6)
                            Spacer()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .frame(width: 340, height: 50)
                        .background(Colors.lightOrangeBackground)
                        .shadow(color: .gray, radius: 5, x: 0.0, y: 5.0)
                        .padding(.vertical, 8)
                    }
                    
                    ForEach(0..<unfinished) { _ in
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
                                .foregroundColor(Colors.blueText)
                            Spacer()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(.horizontal)
                        .padding(.vertical, 6)
                        .frame(width: 340, height: 50)
                        .background(Colors.lightOrangeBackground)
                        .clipped()
                        .shadow(color: .gray, radius: 5, x: 0.0, y: 5.0)
                        .padding(.vertical, 8)
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


