//
//  CreateAccount.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//
import SwiftUI
import Foundation

struct CreateAccount: View {
    
    @EnvironmentObject var userSession : UserSession
    
    @State private var shouldNavigate = false
    
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var showInvalidNameOrPhone = false
    
    var body: some View {
        VStack{
            OnboardingTitle(text: "CREATE ACCOUNT")
                .padding(.bottom, Styling.largeUnit)
                .padding(.top, Styling.onboardingTitlePadding)
            
            OnboardingTextEntry(placeholder: "Name", value: $name)
            
            Spacing(height: Styling.mediumUnit)
            
            HStack {
                Text("+1")
                    .frame(height: 45, alignment: .center)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                
                TextField(
                    "Phone Number",
                    text: $phoneNumber
                )
                .font(.system(size: 20))
                .frame(height: 50, alignment: .center)
                .padding(.leading, 2)
                .foregroundColor(.black)
            }
            .background(Colors.lightOrangeBackground)
            .cornerRadius(5)
            
            Spacing(height: Styling.largeUnit)
            
            OnboardingActionButton(action: {
                let parsedPhoneNumber = UtilFunctions.parsePhoneNumber(phoneNumber: self.phoneNumber)
                if (UtilFunctions.isValidNameAndPhone(name: self.name, phoneNumber: parsedPhoneNumber)) {
                    userSession.createUser(userName: self.name, phoneNumber: parsedPhoneNumber)
                    shouldNavigate = true
                } else {
                    self.showInvalidNameOrPhone = true
                }
            }, text: "CREATE ACCOUNT")
            
            NavigationLink(destination: JoinGroup(), isActive: $userSession.navigateToJoinGroup) { EmptyView() }
            Filler()
        }
        .padding(.horizontal, Styling.mediumUnit)
        .background(Colors.darkOrangeForeground)
        .alert("Please enter a name and valid 10 digit phone number", isPresented: $showInvalidNameOrPhone) {
            Button("OK", role: .cancel) { }
        }
        .alert("A user with this number already exists", isPresented: $userSession.showUserExists) {
            Button("OK", role: .cancel) { }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
