//
//  Main.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct Main: View {
    
    @State var user : User
    @State var viewModel : GoalViewModel
    @State var selection = 2
    @State var showResultsModal : Bool
    @State var showBanner = false

    
    init (user: User, showReflection : Bool) {
        self.user = user
        self.showResultsModal = showReflection
        self.viewModel = GoalViewModel(user : user)
    }
    var body: some View {
        ZStack{
            VStack(spacing:0) {
                if (showBanner) {
                    BannerModifier(user: self.viewModel.user, tab: $selection)
                }
                TabView(selection: $selection) {
                    ProfilePage(viewModel: viewModel)
                        .tabItem {
                            Label ("Profile", systemImage: "person.crop.circle")
                                .foregroundColor(.black)
                        }
                        .tag(1)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    Homepage(viewModel: viewModel, showReflectionPrompt: showBanner)
                        .tabItem {
                            Label ("Home", systemImage: "house.fill")
                        }
                        .tag(2)
                        .navigationBarTitle("", displayMode: .inline)
                        .navigationBarBackButtonHidden(true)
                    SquadPage(viewModel: viewModel, isReviewing: $showBanner)
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
                ResultsAlert(shown: $showResultsModal, showBanner: $showBanner, viewModel: self.viewModel, tab: $selection)
            }
        }
        .task {
            if (user.phoneNumber != "" && user.groupId != "") {
                await self.viewModel.getGoals(phoneNumber: user.phoneNumber)
                self.viewModel.getTeamMemberPhoneNumbers()
                self.viewModel.calculateWeek()
            }
        }
    }
}
