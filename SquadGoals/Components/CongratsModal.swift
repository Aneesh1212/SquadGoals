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
    @State var teammateNotSelected = false
    weak var gestureRecognizer: GestureRecognizerInteractor? = UIApplication.shared
    @State var customMessage = "Congrats on accomplishing your goals so well this week!"
    
    let placeholder = "Congrats on accomplishing your goals so well this week!"
    
    init(viewModel: GoalViewModel, showModal: Binding<Bool>) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._showModal = showModal
        self._teammate = State(wrappedValue: viewModel.user.teammates.first ?? User(name: "", phoneNumber: "", groupId: "", goals: [], teammates: []))
    }
    
    var body: some View {
        VStack() {
            Text("Note of congratulations")
                .bold()
                .font(.system(size: 26))
                .padding(.top, 40)
                .padding(.bottom, 24)
                .fixedSize(horizontal: true, vertical: true)
                .foregroundColor(Color.black)
            
            Text("Choose a squad member to send congrats!")
                .font(.system(size: 20))
                .multilineTextAlignment(.center)
                .foregroundColor(Color.black)
                .fixedSize(horizontal: true, vertical: true)
            
            Picker("Teammate", selection: $teammate) {
                ForEach(viewModel.user.teammates, id: \.self) {
                    Text($0.name)
                        .foregroundColor(Color.black)
                        .tag($0)
                }
            }
            .pickerStyle(.wheel)
            
            TextEditor(
                text: $customMessage
            )
                .font(.system(size: 20))
                .frame(height: 90, alignment: .center)
                .fixedSize(horizontal: false, vertical: false)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.bottom, 24)
                .foregroundColor(self.customMessage == placeholder ? .gray : .black)
                .onTapGesture {
                    if self.customMessage == placeholder {
                        self.customMessage = ""
                    }
                }
            
            Button(action: {
                if (teammate.phoneNumber != "") {
                    self.teammateNotSelected = false
                    viewModel.sendNotification(users: [teammate], title: "Squad Goals: Congrats!", message: self.customMessage == placeholder ? "Congrats on accomplishing your goals so well this week! - \(String(viewModel.user.name))" : "\(self.customMessage) - \(String(viewModel.user.name))")
                    self.showModal = false
                } else {
                    self.teammateNotSelected = true
                }
                
            }) {
                Text("Send") 
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
        .alert("Please select a squad member to congratulate", isPresented: $teammateNotSelected) {
            Button("OK", role: .cancel) { }
        }
        .padding(.horizontal, 16)
        .background(Colors.lightOrangeBackground)
    }
}
