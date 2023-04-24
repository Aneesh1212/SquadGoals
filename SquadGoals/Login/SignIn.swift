//
//  SignIn.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//
import SwiftUI
import Foundation

struct SignIn: View {
    
    @StateObject var viewModel = LoginViewModel()
    
    @State private var phoneNumber: String = ""
    @State private var showInvalidNameOrPhone = false
    
    var body: some View {
        VStack(alignment: .leading){
            Title(text: "Welcome Back!")
            Spacing(height: 6)
            Subtitle(text: "Please enter your address below to start using app.")
            
            Spacing(height: Styling.mediumUnit)
            
            Subtitle(text: "Phone number")
            OnboardingTextEntry(placeholder: "Enter here", value: $phoneNumber)
            
            Filler()
            
            BlueActionButton(text: "Log In", action: signIn)
            
            NavigationLink(destination: Main(user: viewModel.currentUser, showReflection : viewModel.showReflection), isActive: $viewModel.navigateToHome) { EmptyView() }
        }
        .padding(.bottom, Styling.mediumUnit)
        .padding(.horizontal, Styling.mediumUnit)
        .background(Colors.background)
        .alert("Unable to find a user account with this phone number", isPresented: $viewModel.showUnableToFindUser) {
            Button("Retry", role: .cancel) { }
        }
        .alert("Please enter a name and valid 10 digit phone number", isPresented: $showInvalidNameOrPhone) {
            Button("OK", role: .cancel) { }
        }
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
    
    func signIn() {
        let parsedPhoneNumber = viewModel.parsePhoneNumber(phoneNumber: self.phoneNumber)
        if (viewModel.isValidNameAndPhone(name: "Ansh", phoneNumber: parsedPhoneNumber)) {
            viewModel.signUserIn(phoneNumber: parsedPhoneNumber)
        } else {
            self.showInvalidNameOrPhone = true
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
