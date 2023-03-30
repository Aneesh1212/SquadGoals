//
//  HomepageGoalView.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/21/21.
//

import Foundation
import SwiftUI

struct BragTable : View {
    
    @State var goalKey : String
    @StateObject var viewModel = GoalViewModel(user: User(name: "", phoneNumber: "", groupId: "", goals: [], teammates: []))
    @State var bragText = ""
    
    var body : some View {
        VStack (alignment: .leading, spacing: 0){
            VStack(spacing: 0){
                ForEach(self.viewModel.currBrags, id: \.self) { brag in
                    HStack(spacing : 0){
                        Text("\"\(brag.text)\"")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .background(Rectangle().fill(.white).shadow(radius: 3))
                }
                
                HStack{
                    TextField(
                        "",
                        text: $bragText
                    )
                        .background(Colors.progressBarBackground)
                        .padding(4)
                        .foregroundColor(.black)
                    
                    PurpleActionButton(text: "Submit", action: {
                        self.viewModel.createBrag(goalId: self.goalKey, brag: Brag(text: self.bragText))
                        self.viewModel.currBrags.append(Brag(text: self.bragText))
                        self.bragText = ""
                    })
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .padding(.vertical, 2)
                .background(Rectangle().fill(.white).shadow(radius: 3))
            }
            .border(.gray, width: 0.5)
        }
        .onAppear{
            self.viewModel.getBrags(goalKey: self.goalKey)
        }
    }
}

