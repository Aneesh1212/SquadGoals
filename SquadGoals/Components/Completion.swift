//
//  Completion.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/22/21.
//

import Foundation
import SwiftUI

struct Completion: View {
    @EnvironmentObject var viewModel : GoalViewModel
    
    var body: some View {
        VStack {
            ZStack{
                Image(uiImage: UIImage(named: "completion_badge_light")!)
                    .resizable()
                    .offset(y: 13)
                Text("\(viewModel.completedTargets) / \(viewModel.totalTargets) \n TARGETS \n COMPLETED")
                    .foregroundColor(Colors.blueText)
                    .font(.system(size: 20))
                    .multilineTextAlignment(.center)
            }
            .frame(width: 175.0, height: 150.0)


            Text("CONGRATS CHAMP!")
                .foregroundColor(Colors.darkOrangeForeground)
                .font(.system(size: 36, weight: .heavy))
                .multilineTextAlignment(.center)
                .padding(.bottom, 25)
            
            Text("YOU FINISHED ALL YOUR WEEKLY TASKS")
                .foregroundColor(Colors.darkOrangeForeground)
                .font(.system(size: 24))
                .multilineTextAlignment(.center)
            
            Filler()
        }
        .background(Colors.darkOrangeForeground)
        .cornerRadius(15)
    }
}
