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
    @State var selectedUser : User = User(name: "", phoneNumber: "", groupId: "", goals: [], teammates: [])
    @State var shouldNavigateToProfile = false
    @State var showEncouragementModal = false
    @State var showCongratsModal = false
    
    var body: some View {
        
        let weekPercentage : Float = Float(viewModel.getDayOfWeek()) / 7.0
        let teamPercentage : Float = viewModel.calculateTeamTargetPercent()
        let progressString = getProgressString(teamPercentage: teamPercentage, weekPercentage: weekPercentage)
        
        VStack(spacing: 0) {
            VStack{
                VStack(alignment: .leading){
                    Text("TEAM PROGRESS THIS WEEK")
                        .padding(.top, 20)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.white)
                    
                    Text(progressString)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    
                    HStack { Spacer() }
                    
                }
                .padding(.horizontal, 25)
                
                VStack{
                    HStack { Spacer() }
                    
                    ProgressBar(progressValue: teamPercentage, text: "\(String(Int(teamPercentage*100.0))) %")
                        .frame(width: 100.0, height: 100.0)
                        .padding(.bottom, 10.0)
                    
                    Spacer()
                        .frame(height: 15)
                }
                .padding(.bottom, 10)
                
                HStack(spacing: 0) {
                    VStack {
                        Text("Nudge Team")
                            .font(.system(size: 16).bold())
                            .foregroundColor(Colors.lightOrangeBackground)
                            .padding(.vertical, 4)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .border(.white, width: 1)
                    .onTapGesture {
                        self.showEncouragementModal = true
                    }
                    
                    VStack {
                        Text("Send a Congrats")
                            .font(.system(size: 16).bold())
                            .foregroundColor(Colors.lightOrangeBackground)
                            .padding(.vertical, 4)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .border(.white, width: 1)
                    .onTapGesture {
                        self.showCongratsModal = true
                    }
                }
                .shadow(color: .gray, radius: 5, x: 0.0, y: -5.0)
            }
            .background(Colors.darkOrangeForeground)
            
            NavigationLink(destination: UserPage(user: self.selectedUser), isActive: $shouldNavigateToProfile) { EmptyView() }
            
            VStack{
                ScrollView{
                    let columns = [
                        GridItem(.flexible()),
                        GridItem(.flexible())]
                    
                    let teamList = [viewModel.user] + viewModel.user.teammates
                    
                    
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(teamList, id: \.self) { teammate in
                            let teammatePercentage = viewModel.calculateWeeklyTargetPercent(goals: teammate.goals)
                            let totalTargets = viewModel.calculateTotalTargets(goals: teammate.goals)
                            let completedTargets = viewModel.calculateCompletedTargets(goals: teammate.goals)
                            
                            Button(action: {
                                self.selectedUser = teammate
                                self.shouldNavigateToProfile = true
                            }, label: {
                                VStack {
                                    ProgressBar(progressValue: teammatePercentage, text: teammate.name)
                                        .frame(width: 100.0, height: 100.0)
                                        .padding(.bottom, 10.0)
                                    Text("\(completedTargets)/\(totalTargets) targets")
                                        .foregroundColor(Colors.blueText)
                                    Text("See more >")
                                        .foregroundColor(Colors.blueText)
                                        .underline()
                                }
                            })
                        }
                    }
                    .padding(.top, 5)
                }
                .padding(.top, 20)
            }
            Spacer()
        }
        .sheet(isPresented: $showEncouragementModal, onDismiss: {}, content: {
            EncouragementModal(viewModel: self.viewModel, showModal: $showEncouragementModal)
                .background(.white)
                .onAppear{
                    UITextView.appearance().backgroundColor = .clear
                }
        })
        .sheet(isPresented: $showCongratsModal, onDismiss: {}, content: {
            CongratsModal(viewModel: self.viewModel, showModal: $showCongratsModal)
                .background(.white)
                .onAppear{
                    UITextView.appearance().backgroundColor = .clear
                }
        })
        .background(Colors.lightOrangeBackground)
    }
}

func getProgressString(teamPercentage: Float, weekPercentage: Float) -> String {
    if (teamPercentage >= weekPercentage) {
        return "Kudos! Your squad is on track to complete all Tasks."
    } else if (teamPercentage >= weekPercentage / 2) {
        return "Your squad is behind track to complete all Tasks."
    } else {
        return "Your squad is behind track to complete all Tasks."
    }
}
