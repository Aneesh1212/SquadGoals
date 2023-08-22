//
//  CreateAccount.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//
import SwiftUI
import Foundation

struct CreateAccount: View {
    
    @StateObject var viewModel = GoalViewModel()
        
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var showInvalidNameOrPhone = false
    
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                Title(text: "Create New Account")
                Spacing(height:6)
                Subtitle(text: "Please enter your information below to create a new account for using the app.")
                
                Spacing(height: Styling.largeUnit)
                
                Subtitle(text: "Name")
                OnboardingTextEntry(placeholder: "Enter name", value: $name)
                
                Spacing(height: Styling.smallUnit)
                
                Subtitle(text: "Phone number")
                TextField(
                    "XXX-XXX-XXXX",
                    text: $phoneNumber
                )
                    .font(.system(size: 16))
                    .frame(height: 42, alignment: .center)
                    .padding(.leading, 15)
                    .background(.white)
                    .cornerRadius(Styling.smallUnit)
                    .foregroundColor(.black)
                    .onChange(of: phoneNumber, perform: { _ in
                        phoneNumber = UtilFunctions.formatPhoneNumber(phone: phoneNumber)
                    })
            }
            
            Filler()
            
            BlueActionButton(text: "Create Account", action: createAccount)
            
            NavigationLink(destination: JoinGroup(viewModel: self.viewModel), isActive: $viewModel.navigateToJoinGroup) { EmptyView() }
            
        }
        .padding(.bottom, Styling.mediumUnit)
        .padding(.top, Styling.smallUnit)
        .padding(.horizontal, Styling.mediumUnit)
        .background(Colors.background)
        .alert("Please enter a name and valid 10 digit phone number", isPresented: $showInvalidNameOrPhone) {
            Button("OK", role: .cancel) { }
        }
        .alert("A user with this number already exists", isPresented: $viewModel.showUserExists) {
            Button("OK", role: .cancel) { }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    func createAccount() {
        let parsedPhoneNumber = UtilFunctions.parsePhoneNumber(phoneNumber: self.phoneNumber)
        if (UtilFunctions.isValidNameAndPhone(name: self.name, phoneNumber: parsedPhoneNumber)) {
            viewModel.createUser(userName: self.name, phoneNumber: parsedPhoneNumber)
        } else {
            self.showInvalidNameOrPhone = true
        }
    }
}
