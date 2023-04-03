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
    var primaryAction: () -> Void
    var buttonAction: () -> Void

    var body: some View {
        
        Button(action: primaryAction, label: {
            VStack(spacing: 12) {
                HStack{
                    Subtitle(text: name, weight: .semibold)
                    Spacer()
                    Subtitle(text: "🔥\(momentum)")
                }
                
                ProgressBar(progressValue: percentage, weekPercentage: weekPercentage, text: "\(String(Int(percentage*100.0)))%", isLargeVersion: false)
                    .frame(width: 60.0, height: 60.0)
                
                BlueActionButton(text: "Message", action: buttonAction, height: 32)
                
                Text("view more >")
                    .underline()
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(.white)
            .cornerRadius(20)
        })
    }
}



