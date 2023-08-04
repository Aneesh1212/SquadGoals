//
//  GoalAdded.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct GoalAdded: View {
    
    @State var viewModel : GoalViewModel
    @State var goalTitle : String
    @State var navigateToMondayPlanning = false
    @State var navigateToCreateGoal = false
    
    var body: some View {
        VStack(alignment: .leading){
            Title(text: goalTitle, lineLimit: 2, shouldLeftAlign: true)
            Spacing(height:6)
            Subtitle(text: "Added")
            
            Spacer()

            BlueActionButton(text: "+ Add Another Goal", action: {
                self.navigateToCreateGoal = true
            })
            
            Spacing(height:Styling.smallUnit)
            
            OrangeActionButton(text: "Finished", action: {
                self.navigateToMondayPlanning = true
            })
            
            Filler()
            
            NavigationLink(destination: CreateGoal(viewModel: self.viewModel, isSingleGoal: false), isActive: $navigateToCreateGoal) { EmptyView() }
            
            NavigationLink(destination: MondayPlanning(viewModel: viewModel, mode: Mode.initial), isActive: $navigateToMondayPlanning) { EmptyView() }
                        
        }
        .padding(.bottom, Styling.mediumUnit)
        .padding(.top, Styling.smallUnit)
        .padding(.horizontal, Styling.mediumUnit)
        .background(Colors.background)
    }
}
