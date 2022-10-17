//
//  EnterPhone.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//

import Foundation
import SwiftUI

struct Welcome: View {
    
    @StateObject var loginData = LoginViewModel()
    
    @State var navigateToSignIn = false
    @State var navigateToCreateAccount = false
    var viewModel = NotificationViewModel()
    
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
            
            
            NavigationLink(destination: CreateAccount(), isActive: $navigateToCreateAccount) { EmptyView() }
            NavigationLink(destination: SignIn(), isActive: $navigateToSignIn) { EmptyView() }
            
            HStack {
                Spacer()
            }
            
            Spacer()
            
        }
        .background(Colors.darkOrangeForeground)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
