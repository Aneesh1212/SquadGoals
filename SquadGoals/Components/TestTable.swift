//
//  TestTable.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 5/23/22.
//

import Firebase

//
//  GoalAdded.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI
import SwiftUITooltip

struct TestTable: View {
    
    var ref = Database.database().reference()
    @State var goalKey : String
    @State var goalTitle : String
    @Binding var titles : [String]
    @Binding var frequencies : [String]
    @Binding var keys : [String]
    @State var toolTipConfig = DefaultTooltipConfig()
    @State var showToolTip : Bool
    
    var frequencyOptions : Array<String> = ["Once", "2x", "3x", "4x", "5x", "6x", "7x"]
    
    var body: some View {
        VStack(spacing:0){
            Text(goalTitle)
                .fixedSize(horizontal: false, vertical: true)
                .multilineTextAlignment(.center)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Rectangle().fill(Colors.blueGoalHeader).shadow(radius: 3))
                .foregroundColor(Color.white)
            ForEach(0..<titles.count, id: \.self) { index in
                HStack(spacing: 0) {
                    TextField(
                        "Weekly target.. ",
                        text: $titles[index]
                    )
                    .foregroundColor(.black)
                    Spacer()
                    Picker(selection: $frequencies[index],
                           label: Text(self.frequencies[index]),
                           content: {
                        ForEach(frequencyOptions, id: \.self) { frequencyWord in
                            Text(frequencyWord).tag(frequencyWord)
                        }
                    })
                    .pickerStyle(MenuPickerStyle())
                    .fixedSize()
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding()
                .background(Rectangle().fill(Colors.targetsListBackground).shadow(radius: 3))                }
            HStack{
                Button(action: {
                    self.titles.append("")
                    self.frequencies.append("Once")
                    let targetsRef = self.ref.child("targets").child(goalKey)
                    let targetKey = targetsRef.childByAutoId().key ?? ""
                    self.keys.append(targetKey)
                    self.showToolTip = false
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .padding(6)
                        .frame(width: 24, height: 24)
                        .background(Color.green)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                    Text("Add new")
                        .padding(.leading, 3)
                        .foregroundColor(.black)
                }
                
                Spacer()
                
                Button(action: {
                    self.titles.popLast()
                    self.frequencies.popLast()
                    let deletedTargetKey = self.keys.popLast() ?? ""
                    if (deletedTargetKey != "") {
                        let reference = ref.child("targets").child(goalKey).child(deletedTargetKey)
                        reference.removeValue()
                    }
                }) {
                    Image(systemName: "minus")
                        .resizable()
                        .padding(6)
                        .frame(width: 24, height: 24)
                        .background(Color.red)
                        .clipShape(Circle())
                        .foregroundColor(.white)
                    Text("Delete")
                        .padding(.leading, 3)
                        .foregroundColor(.black)
                }
            }
            .fixedSize(horizontal: false, vertical: true)
            .padding()
            .background(Rectangle().fill(Colors.targetsListBackground).shadow(radius: 3))
            .tooltip(showToolTip, config: toolTipConfig, content: {
                Button(action: {
                    self.showToolTip = false
                }, label: {
                    HStack(alignment: .top) {
                        Text("Add new Task here for your Goal. If your goal is a habit like 'Meditate' - add the Task 'Meditate' and adjust the Frequency.\n \n If your goal is 'Get a new job', add a Task like 'Edit Resume' or 'Apply to 5 jobs' and adjust the Frequency")
                        Text("X")
                    }
                    .frame(width: 300)
                    .fixedSize(horizontal: false, vertical: true)
                    .foregroundColor(.black)
                    .font(.system(size: 12))
                })
            })
        }
        .onAppear {
            toolTipConfig.backgroundColor = Colors.lightOrangeBackground
            toolTipConfig.borderColor = .black
            toolTipConfig.borderWidth = 1
            toolTipConfig.side = .bottom
            toolTipConfig.margin = -15
        }
    }
}
