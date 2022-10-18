//
//  GoalAdded.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct GoalAdded: View {
    
    @State var user : User
    @State var goalTitle : String
    @State var navigateToSundayPlanning = false
    @State var navigateToCreateGoal = false
    
    var body: some View {
        VStack{
            Title(text:"\"\(goalTitle.uppercased())\" ADDED!")
                .padding(.top, Styling.onboardingTitlePadding)
                .padding(.bottom, Styling.largeUnit)

            Button(action: {
                self.navigateToCreateGoal = true
            }) {
                Text("Add Another Goal")
                    .foregroundColor(Colors.lightOrangeBackground)
                    .font(.system(size: 22))
                    .frame(width: 300, height: 70, alignment: .center)
                    .background(Colors.blueText)
                    .cornerRadius(15)
                    .padding(.bottom, Styling.mediumUnit)
            }
            
            Button(action: {
                self.navigateToSundayPlanning = true
            }) {
                Text("Finished")
                    .foregroundColor(Colors.lightOrangeBackground)
                    .font(.system(size: 22))
                    .frame(width: 300, height: 70, alignment: .center)
                    .background(Colors.blueText)
                    .cornerRadius(15)
            }
            
            NavigationLink(destination: CreateGoal(user: self.user, isSingleGoal: false), isActive: $navigateToCreateGoal) { EmptyView() }
            
            NavigationLink(destination: SundayPlanning(user: self.user, viewModel: GoalViewModel(user:self.user), mode: Mode.initial), isActive: $navigateToSundayPlanning) { EmptyView() }
            
            Filler()
            
        }
        .background(Colors.darkOrangeForeground)
    }
}
