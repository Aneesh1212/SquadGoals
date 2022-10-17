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
        VStack{
            OnboardingTitle(text: "SIGN IN")
                .padding(.bottom, Styling.largeUnit)
                .padding(.top, Styling.onboardingTitlePadding)
            
            HStack {
                Text("+1")
                    .frame(height: 45, alignment: .center)
                    .font(.system(size: 20))
                    .foregroundColor(.gray)
                    .padding(.leading, 15)
                
                TextField(
                    "Enter your phone number",
                    text: $phoneNumber)
                
                .font(.system(size: 20))
                .frame(height: 50, alignment: .center)
                .padding(.leading, 2)
                .foregroundColor(.black)
            }
            .background(Color.white)
            .cornerRadius(5)
            .padding(.bottom, Styling.mediumUnit)
            
            NavigationLink(destination: Main(user: viewModel.currentUser, showReflection : viewModel.showReflection), isActive: $viewModel.navigateToHome) { EmptyView() }
            
            OnboardingActionButton(action: {
                let parsedPhoneNumber = viewModel.parsePhoneNumber(phoneNumber: self.phoneNumber)
                if (viewModel.isValidNameAndPhone(name: "Ansh", phoneNumber: parsedPhoneNumber)) {
                    viewModel.signUserIn(phoneNumber: parsedPhoneNumber)
                } else {
                    self.showInvalidNameOrPhone = true
                }
            }, text: "SIGN IN")
            
            Spacer()
            
            HStack{
                Spacer()
            }
            
        }
        .padding(.horizontal, Styling.mediumUnit)
        .background(Colors.darkOrangeForeground)
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
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
