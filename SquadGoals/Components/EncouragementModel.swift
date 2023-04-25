//
//  EncouragementModel.swift
//  SquadGoals
//
//  Created by Aneesh Agrawal on 4/10/22.
//

import Foundation
import SwiftUI

struct EncouragementModal: View {
    @StateObject var viewModel : GoalViewModel
    @Binding var showModal : Bool
    @State var customMessage = "Or write custom note.."    
    let placeholder = "Or write custom note.."
    var defaultMessage = "There's time left in the week, let's finish a few more tasks!"
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Title(text: "Send a Message \nto the Entire Squad", lineLimit: 2, size: 36, shouldLeftAlign: true)
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
            .cornerRadius(10)
            .foregroundColor(self.customMessage == placeholder ? .gray : .black)
            .onTapGesture {
                if self.customMessage == placeholder {
                    self.customMessage = ""
                }
            }
            
            Filler()
            
            BlueActionButton(text: "Send to Squad", action: {
                UtilFunctions.sendNotification(users: viewModel.user.teammates + [viewModel.user], title: "New message from \(viewModel.user.name)", message: self.customMessage == placeholder ? defaultMessage : self.customMessage)
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
