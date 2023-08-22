//
//  SquadsModal.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 4/10/22.
//

import Foundation
import SwiftUI

struct SquadsModal: View {
    @StateObject var viewModel : GoalViewModel
    @Binding var showModal : Bool
    weak var gestureRecognizer: GestureRecognizerInteractor? = UIApplication.shared
    
    var body: some View {
        
        VStack(alignment:.center) {
            Title(text: "Current Squad ID: \(viewModel.user.groupId)")
            Spacing(height: Styling.mediumUnit)
            Subtitle(text: "Switch between squads")
            ScrollView {
                ForEach(viewModel.user.squads, id: \.self) { squadId in
                    if (squadId != viewModel.user.groupId) {
                        WhiteActionButton(text: squadId, action: {
                            viewModel.user.groupId = squadId
                            viewModel.getGoals()
                            viewModel.getTeamMemberPhoneNumbers()
                            viewModel.calculateWeek()
                            showModal = false
                        })
                    }
                }
            }
            
            Filler()
            
            TextFie
            
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .padding(Styling.mediumUnit)
        .background(Colors.background)
    }
}
