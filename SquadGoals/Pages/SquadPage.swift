//
//  SquadPage.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct SquadPage: View {
    
    @StateObject var viewModel : GoalViewModel
    @Binding var isReviewing: Bool
    @State var selectedUser : User = User(name: "", phoneNumber: "", groupId: "", goals: [], teammates: [])
    @State var shouldNavigateToProfile = false
    @State var showEncouragementModal = false
    @State var showCongratsModal = false
    
    var body: some View {
        
        let weekPercentage : Float = isReviewing ? 1.0 : Float(UtilFunctions.getDayOfWeek()) / 7.0
        let teamPercentage : Float = viewModel.calculateTeamTargetPercent()
        let progressString = isReviewing ? getFinishedProgressString(teamPercentage: teamPercentage) : getCurrentProgressString(teamPercentage: teamPercentage, weekPercentage: weekPercentage)
        let teamList = [viewModel.user] + viewModel.user.teammates
        let columns = [GridItem(.flexible()), GridItem(.flexible())]
        
        
        VStack(spacing: 0) {
            OrangeCard {
                    TitleV2(text: "Team Progress this Week")
                    SubtitleV2(text: progressString)
                    ProgressBar(progressValue: teamPercentage, weekPercentage: weekPercentage, text: "\(String(Int(teamPercentage*100.0))) %")
                        .frame(width: 75.0, height: 75.0)
                    WhiteActionButton(text: "Message Team", action: {
                        self.showEncouragementModal = true
                    })
            }
            .padding(.bottom, Styling.smallUnit)
            
            NavigationLink(destination: UserPage(user: self.selectedUser), isActive: $shouldNavigateToProfile) { EmptyView() }
            
            ScrollView{
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(teamList, id: \.self) { teammate in
                        let teammatePercentage = viewModel.calculateWeeklyTargetPercent(goals: teammate.goals)
                        
                        UserProgressCard(percentage: teammatePercentage, weekPercentage: weekPercentage, name: teammate.name, momentum: 12, action: {
                                self.selectedUser = teammate
                                self.shouldNavigateToProfile = true
                        })
                    }
                }
            }
            
            Spacer()
        }
        .padding(.horizontal, 25)
        .background(Colors.background)
        .sheet(isPresented: $showEncouragementModal, onDismiss: {}, content: {
            EncouragementModal(viewModel: self.viewModel, showModal: $showEncouragementModal)
            
        })
        .sheet(isPresented: $showCongratsModal, onDismiss: {}, content: {
            CongratsModal(viewModel: self.viewModel, showModal: $showCongratsModal)
        })
    }
}

func getCurrentProgressString(teamPercentage: Float, weekPercentage: Float) -> String {
    if (teamPercentage >= weekPercentage) {
        return "Kudos! Your squad is on track to complete all tasks."
    } else if (teamPercentage >= weekPercentage / 2 ) {
        return "Your squad is making good progress but behind the day of the week pace."
    } else {
        return "Your squad is behind track to complete all tasks."
    }
}

func getFinishedProgressString(teamPercentage: Float) -> String {
    if (teamPercentage == 1.0) {
        return "Unreal job! Your squad completed all your Tasks. You deserve to celebrate."
    } else if (teamPercentage >= 0.65) {
        return "Kudos! Your squad finished most of your Tasks. Take some time to celebrate."
    } else {
        return "Your squad finished some tasks, let's work harder next week."
    }
}
