//
//  EnterPhone.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//

import Foundation
import SwiftUI

struct Welcome: View {        
    var shouldTryToSignIn : Bool
    @State var navigateToSignIn = false
    @State var navigateToCreateAccount = false
    @StateObject var viewModel = LoginViewModel()

    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            Image(uiImage: UIImage(named: "boat")!)
            
            Spacer()
            
            Title(text: "Squad Goals", size: 40)
            
            Subtitle(text: "A rising tide lifts all boats")
                .padding(.bottom, Styling.mediumUnit)
                     
            HStack {
                Spacer()
            }
                        
            Button(action: {
                navigateToSignIn = true
            }) {
                BlueActionButton(text: "Log In")
            }
            
            Spacer()
                .frame(height: 20)
            
            Button(action: {
                navigateToCreateAccount = true
            }) {
                OrangeActionButton(text: "Create Account")
            }
            
            
            VStack {
                NavigationLink(destination: CreateAccount(), isActive: $navigateToCreateAccount) { EmptyView() }
                NavigationLink(destination: SignIn(), isActive: $navigateToSignIn) { EmptyView() }
                NavigationLink(destination: Main(user: viewModel.currentUser, showReflection: viewModel.showReflection), isActive: $viewModel.navigateToHome) { EmptyView() }
            }
            
                        
        }
        .padding(.horizontal, Styling.mediumUnit)
        .background(Colors.background)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .onAppear {
            if (shouldTryToSignIn) {
                viewModel.tryAutoSignIn()
            }
        }
    }
}
