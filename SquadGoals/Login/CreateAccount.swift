//
//  CreateAccount.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//
import SwiftUI
import Foundation

struct CreateAccount: View {
    
    @StateObject var viewModel = LoginViewModel()
        
    @State private var name: String = ""
    @State private var phoneNumber: String = ""
    
    @State private var showInvalidNameOrPhone = false
    
    var body: some View {
        VStack(alignment: .leading){
            VStack(alignment: .leading){
                Title(text: "Create New Account")
                Subtitle(text: "Please enter your information below to create a new account for using the app.")
                
                Spacing(height: Styling.largeUnit)
                
                Subtitle(text: "Name")
                OnboardingTextEntry(placeholder: "Enter here", value: $name)
                
                Spacing(height: Styling.smallUnit)
                
                Subtitle(text: "Phone number")
                OnboardingTextEntry(placeholder: "Enter here", value: $phoneNumber)
            }
            
            Filler()
            
            BlueActionButton(text: "Create Account", action: createAccount)
            
            NavigationLink(destination: JoinGroup(viewModel: self.viewModel), isActive: $viewModel.navigateToJoinGroup) { EmptyView() }
            
        }
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
        /*let parsedPhoneNumber = viewModel.parsePhoneNumber(phoneNumber: self.phoneNumber)
        if (viewModel.isValidNameAndPhone(name: self.name, phoneNumber: parsedPhoneNumber)) {
            viewModel.createUser(userName: self.name, phoneNumber: parsedPhoneNumber)
            shouldNavigate = true
        } else {
            self.showInvalidNameOrPhone = true
        }*/
        self.viewModel.navigateToJoinGroup = true
    }
}
