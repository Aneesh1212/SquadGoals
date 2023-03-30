//
//  UserProgressCard.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 3/28/23.
//

import SwiftUI

struct UserProgressCard: View {
    
    var percentage: Float
    var weekPercentage : Float
    var name: String
    var momentum : Int
    var action: () -> Void

    var body: some View {
        
        Button(action: action, label: {
            VStack {
                HStack{
                    Subtitle(text: name)
                    Spacer()
                    Subtitle(text: "🔥\(momentum)")
                }
                
                ProgressBar(progressValue: percentage, weekPercentage: weekPercentage, text: "\(String(Int(percentage*100.0))) %")
                    .frame(width: 60.0, height: 60.0)
                
                PurpleActionButton(text: "Message", action: action)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(20)
        })
    }
}



