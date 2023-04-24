//
//  EncouragementModel.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 4/10/22.
//

import Foundation
import SwiftUI

struct CongratsModal: View {
    @StateObject var viewModel : GoalViewModel
    @Binding var showModal : Bool
    @State var teammate: User;
    weak var gestureRecognizer: GestureRecognizerInteractor? = UIApplication.shared
    @State var customMessage = "Or write a custom note..."
    let placeholder = "Or write a custom note..."
    var defaultMessage = "Way to crush that last task! You're an inspiration!"
    
    var body: some View {
        VStack(alignment:.leading) {
            Title(text: "Send a Kudos \nto \(teammate.name)", lineLimit: 2, size: 36, shouldLeftAlign: true)
            Spacing(height: Styling.mediumUnit)
            Subtitle(text: "\"\(defaultMessage)\"")
            
            TextEditor(
                text: $customMessage
            )
            .font(.system(size: 16))
            .frame(height: 120, alignment: .center)
            .fixedSize(horizontal: false, vertical: false)
            .padding(Styling.extraSmallUnit)
            .background(Color.white)
            .foregroundColor(self.customMessage == placeholder ? .gray : .black)
            .onTapGesture {
                if self.customMessage == placeholder {
                    self.customMessage = ""
                }
            }
            
            Filler()
            
            BlueActionButton(text: "Send to \(teammate.name)", action: {
                UtilFunctions.sendNotification(users: [teammate], title: "New Congrats from \(viewModel.user.name)!", message: self.customMessage == placeholder ? defaultMessage : self.customMessage)
                self.showModal = false
            })
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .padding(Styling.mediumUnit)
        .background(Colors.background)
    }
}
