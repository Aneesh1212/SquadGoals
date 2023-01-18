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
    
    var body: some View {
        
        VStack(spacing: 24) {
            Text("Note of encouragement")
                .bold()
                .foregroundColor(Color.black)
                .font(.system(size: 26))
                .padding(.top, 40)
                .padding(.bottom, 54)
                .fixedSize(horizontal: false, vertical: true)
            
            
            Text("\"There's time left in the week, lets finish a few more goals!\"")
                .font(.system(size: 20))
                .foregroundColor(Color.black)
                .fixedSize(horizontal: false, vertical: true)
            
            TextEditor(
                text: $customMessage
            )
            .font(.system(size: 20))
            .frame(height: 90, alignment: .center)
            .fixedSize(horizontal: false, vertical: false)
            .background(Color.white)
            .cornerRadius(10)
            .foregroundColor(self.customMessage == placeholder ? .gray : .black)
            .padding(.bottom, 48)
            .onTapGesture {
                if self.customMessage == placeholder {
                    self.customMessage = ""
                }
            }
            
            Button(action: {
                viewModel.sendNotification(users: viewModel.user.teammates + [viewModel.user], title: "Squad Goals: Midweek Encouragement", message: self.customMessage == placeholder ? "There's time left in the week, lets finish a few more goals! - \(String(viewModel.user.name))" : "\(self.customMessage) - \(String(viewModel.user.name))")
                self.showModal = false
            }) {
                Text("Send to team")
                    .foregroundColor(.white)
                    .frame(width: 200, height: 40, alignment: .center)
                    .background(Colors.blueText)
                    .cornerRadius(15)
            }
            
            Spacer()
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .padding(.horizontal, 24)
        .background(Colors.lightOrangeBackground)
    }
}
