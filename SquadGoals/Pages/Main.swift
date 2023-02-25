//
//  Main.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI


struct Main: View {
    @EnvironmentObject var user : User
    @EnvironmentObject var userSession : UserSession
    @State var showResultsModal : Bool
    @State var selection = 2
    @State var showBanner = false
    
    init(showReflection: Bool) {
        self.showResultsModal = showReflection
    }
    var body: some View {
        ZStack{
            VStack(spacing:0) {
                if (showBanner) {
                    BannerModifier(tab: $selection)
                }
                TabView(selection: $selection) {
                    ProfilePage()
                        .tabItem {
                            Label ("Profile", systemImage: "person.crop.circle")
                                .foregroundColor(.black)
                        }
                        .tag(1)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    Homepage(showReflectionPrompt: showBanner)
                        .tabItem {
                            Label ("Home", systemImage: "house.fill")
                        }
                        .tag(2)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    SquadPage(isReviewing: $showBanner)
                        .tabItem {
                            Label ("Squad", systemImage: "person.3.fill")
                        }
                        .tag(3)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .overlay(Color.gray.opacity(showResultsModal ? 0.6 : 0.0))
            .disabled(showResultsModal)
            
            if (showResultsModal) {
                ResultsAlert(shown: $showResultsModal, showBanner: $showBanner)
            }
        }
    }
}
