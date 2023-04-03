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
    @State var navigateToMondayPlanning = false
    @State var navigateToCreateGoal = false
    
    var body: some View {
        VStack(alignment: .leading){
            Title(text: goalTitle, lineLimit: 2)
            Subtitle(text: "Added")
            
            Spacer()

            BlueActionButton(text: "+ Add Another Goal", action: {
                self.navigateToCreateGoal = true
            })
            
            OrangeActionButton(text: "Finished", action: {
                self.navigateToMondayPlanning = true
            })
            
            Filler()
            
            NavigationLink(destination: CreateGoal(user: self.user, isSingleGoal: false), isActive: $navigateToCreateGoal) { EmptyView() }
            
            NavigationLink(destination: MondayPlanning(user: self.user, viewModel: GoalViewModel(user:self.user), mode: Mode.initial), isActive: $navigateToMondayPlanning) { EmptyView() }
                        
        }
        .padding(.bottom, Styling.mediumUnit)
        .padding(.horizontal, Styling.mediumUnit)
        .background(Colors.background)
    }
}
