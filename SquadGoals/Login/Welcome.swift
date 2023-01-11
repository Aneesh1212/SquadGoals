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
        VStack{
            Image(uiImage: UIImage(named: "boat")!)
                .padding(.top, 50)
            
            Title(text: "SQUAD GOALS")
            
            Text("A rising tide lifts all boats")
                .font(.system(size: 16))
                .foregroundColor(.white)
                .padding(.bottom, 35)
                        
            Button(action: {
                navigateToCreateAccount = true
            }) {
                WhiteActionButton(text: "CREATE ACCOUNT")
            }
            
            Spacer()
                .frame(height: 25)
            
            Button(action: {
                navigateToSignIn = true
            }) {
                WhiteActionButton(text: "SIGN IN")
            }
            
            
            VStack {
                NavigationLink(destination: CreateAccount(), isActive: $navigateToCreateAccount) { EmptyView() }
                NavigationLink(destination: SignIn(), isActive: $navigateToSignIn) { EmptyView() }
                NavigationLink(destination: Main(user: viewModel.currentUser, showReflection: viewModel.showReflection), isActive: $viewModel.navigateToHome) { EmptyView() }
            }
            
            HStack {
                Spacer()
            }
            
            Spacer()
            
        }
        .background(Colors.darkOrangeForeground)
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
