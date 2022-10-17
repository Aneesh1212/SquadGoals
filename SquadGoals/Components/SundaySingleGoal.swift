//
//  GoalAdded.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct SundaySingleGoal: View {
    
    @State var goal : Goal
    @Binding var goalTargetMap : Dictionary<Goal, Array<Target>>
    @StateObject var viewModel : GoalViewModel
    @State var workingTitle : String = ""
    @State var workingFrequency : String = "1x/week"
    @State var submitClicked : Bool
    
    var frequencies : Array<String> = ["1x/week", "2x", "3x", "4x", "5x", "6x", "7x"]
    
    var body: some View {
        VStack(spacing:0){
            Text(goal.title)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Rectangle().fill(Colors.blueGoalHeader).shadow(radius: 3))
                .foregroundColor(Color.white)
            
            ForEach(self.goal.currTargets, id: \.self) { target in
                HStack(spacing : 0){
                    Text(target.title)
                    Spacer()
                    Text(String(target.original))
                    Text("x")
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .background(Rectangle().fill(Colors.targetsListBackground).shadow(radius: 3))
                .foregroundColor(.black)
            }
            
            HStack(spacing: 0) {
                TextField(
                    "Weekly target.. ",
                    text: $workingTitle
                )
                    .foregroundColor(.black)
                Spacer()
                Picker(selection: $workingFrequency,
                       label: Text(""),
                       content: {
                    ForEach(frequencies, id: \.self) { frequencyWord in
                        Text(frequencyWord).tag(frequencyWord)
                    }
                })
                    .pickerStyle(MenuPickerStyle())
                    .fixedSize()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Rectangle().fill(Colors.targetsListBackground).shadow(radius: 3))
            
            HStack{
                Button(action: {
                    let targetFrequency = viewModel.convertFrequencyToNum(frequencyWord: self.workingFrequency)
                    let newTarget = Target(title: self.workingTitle, frequency: targetFrequency, original: targetFrequency, key: "ANSH")
                    self.workingTitle = ""
                    self.workingFrequency = "1x/week"
                    viewModel.createTargets(goalId: self.goal.key ?? "", targets: [newTarget])
                    goal.currTargets.append(newTarget)
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(6)
                        .frame(width: 24, height: 24)
                        .background(Color.green)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                }
                Text("Add above target")
                    .padding(.leading, 10)
                    .foregroundColor(.black)
                
                Spacer()
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Rectangle().fill(Colors.targetsListBackground).shadow(radius: 3))
        }
    }
}
