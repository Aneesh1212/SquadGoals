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
    @EnvironmentObject var viewModel : GoalViewModel
    @State var bragText = ""
    
    var body : some View {
        VStack (alignment: .leading, spacing: 0){
            Text("PROUD ACHEIVEMENTS BRAG")
                .foregroundColor(Colors.darkOrangeForeground)
                .font(.system(size: 20))
                .padding(.bottom, 5)
            
            VStack(spacing: 0){
                ForEach(self.viewModel.currBrags, id: \.self) { brag in
                    HStack(spacing : 0){
                        Text("\"\(brag.text)\"")
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .padding()
                    .background(Rectangle().fill(Colors.targetsListBackground).shadow(radius: 3))
                }
                
                HStack{
                    TextField(
                        "",
                        text: $bragText
                    )
                        .background(Colors.progressBarBackground)
                        .padding(4)
                        .foregroundColor(.black)
                    
                    Button(action: {
                        self.viewModel.createBrag(goalId: self.goalKey, brag: Brag(text: self.bragText))
                        self.viewModel.currBrags.append(Brag(text: self.bragText))
                        self.bragText = ""
                    }) {
                        Text("Submit")
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .font(.system(size: 12))
                            .background(Colors.blueText)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .padding(.vertical, 2)
                .background(Rectangle().fill(Colors.targetsListBackground).shadow(radius: 3))
            }
            .border(.gray, width: 0.5)
        }
        .onAppear{
            self.viewModel.getBrags(goalKey: self.goalKey)
        }
    }
}

