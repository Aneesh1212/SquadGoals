//
//  Rce.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/21/21.
//

import Foundation
import SwiftUI

struct Race : View {
    
    @StateObject var viewModel : GoalViewModel
    var colorList = [Color.green, Color.red, Color.blue, Color.pink, Color.gray, Color.purple]
    
    
    var body : some View {
        let teamList = [viewModel.user] + viewModel.user.teammates
        VStack(alignment: .leading, spacing: 0) {
            ZStack {
                ForEach(teamList, id: \.self) { teammate in
                    let index = teamList.firstIndex(of: teammate) ?? 0
                    ZStack {
                        Circle()
                            .background(Circle().foregroundColor(colorList[index % colorList.count]))
                            .foregroundColor(colorList[index % colorList.count])
                            .frame(width: 25, height: 25)
                        Text(teammate.name.prefix(1))
                            .foregroundColor(.white)
                        
                    }
                    .offset(x: CGFloat.init(self.viewModel.calculateWeeklyTargetPercent(goals: teammate.goals) * 320.0))
                    .offset(y: CGFloat.init(Float(index)*10.0))
                    .zIndex(Double(teamList.count - index))
                }
            }
            
            Divider()
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .background(Colors.lightOrangeBackground)
                .foregroundColor(Colors.lightOrangeBackground)
                .padding(.bottom, 5)
                .padding(.top,  CGFloat.init(Float(teamList.count)*10.0))
            
            HStack {
                Text("Starting")
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Colors.lightOrangeBackground)
                
                Spacer()
                
                Text("Finished")
                    .multilineTextAlignment(.trailing)
                    .foregroundColor(Colors.lightOrangeBackground)
            }
        }
    }
}

