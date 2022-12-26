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

struct TestTable: View {
    
    var ref = Database.database().reference()
    @State var goalKey : String
    @State var goalTitle : String
    @Binding var titles : [String]
    @Binding var frequencies : [String]
    @Binding var keys : [String]
    
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
        }
    }
}
