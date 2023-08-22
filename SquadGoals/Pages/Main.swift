//
//  Main.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI


struct Main: View {
    @State var viewModel : GoalViewModel
    @State var showResultsModal : Bool
    @State var selection = 1
    @State var showBanner = false
    
    var body: some View {
        ZStack{
            VStack(spacing:0) {
                if (showBanner) {
                    BannerModifier(viewModel: self.viewModel, tab: $selection)
                }
                TabView(selection: $selection) {
                    Homepage(viewModel: viewModel, showReflectionPrompt: showBanner)
                        .tabItem {
                            Label ("Home", systemImage: "house.fill")
                        }
                        .tag(1)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    SquadPage(viewModel: viewModel, isReviewing: $showBanner)
                        .tabItem {
                            Label ("Squad", systemImage: "person.3.fill")
                        }
                        .tag(2)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    ProfilePage(viewModel: viewModel)
                        .tabItem {
                            Label ("Profile", systemImage: "person.crop.circle")
                                .foregroundColor(.black)
                        }
                        .tag(3)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                }
            }
            .overlay(Color.gray.opacity(showResultsModal ? 0.6 : 0.0))
            .disabled(showResultsModal)
            
            if (showResultsModal) {
                ResultsAlert(shown: $showResultsModal, showBanner: $showBanner, viewModel: self.viewModel)
            }
        }
        .task {
            /* if (viewModel.user.phoneNumber != "" && viewModel.user.groupId != "") {
                self.viewModel.getGoals(phoneNumber: viewModel.user.phoneNumber)
                self.viewModel.getTeamMemberPhoneNumbers()
                self.viewModel.calculateWeek()
            } */ 
        }
    }
}
