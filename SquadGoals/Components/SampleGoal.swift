//
//  SampleGoal.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 8/3/23.
//

import Foundation
import SwiftUI

struct SampleGoal : View {
    
    @Binding var navigateToAddGoal : Bool
    
    var body: some View {
        WhiteCard {
            VStack(spacing: 0) {
                HStack{
                    Subtitle(text: "Your First Goal Here", weight: .medium, size: 18)
                    Spacer()
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 6)
                .padding(.bottom, 6)
                
                WhiteCard(verticalPadding: Styling.extraSmallUnit) {
                    HStack{
                        Image(systemName: "checkmark")
                            .resizable()
                            .padding(6)
                            .frame(width: 20, height: 20)
                            .background(Color.green)
                            .clipShape(Circle())
                            .foregroundColor(.white)
                            .opacity(0.6)
                        Text("Sample Task")
                            .opacity(0.6)
                        Spacer()
                    }
                }
                .padding(.vertical, 6)
                .fixedSize(horizontal: false, vertical: true)
                .shadow(color: .gray, radius: 1, x: 0.0, y: 1.0)
                
                WhiteCard(verticalPadding: Styling.extraSmallUnit) {
                    HStack(){
                        Image(systemName: "circle")
                            .clipShape(Circle())
                            .shadow(radius: 20)
                            .foregroundColor(Color.green)
                        Text("Sample Task")
                        Spacer()
                    }
                }
                .padding(.vertical, 6)
                .fixedSize(horizontal: false, vertical: true)
                .shadow(color: .gray, radius: 1, x: 0.0, y: 1.0)
                
                
                PurpleActionButton(text: "+ Add Goal", height: 42, action: {
                    navigateToAddGoal = true
                })
                .padding(.horizontal, Styling.largeUnit)
                .padding(.top, Styling.extraSmallUnit)
            }
        }
        .padding(.vertical, Styling.smallUnit)
    }
}
    
