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
        
        let progressWord : String = (teamPercentage >= weekPercentage) ? "GREEN" : (teamPercentage >= weekPercentage / 2 ? "YELLOW" : "RED")
        
        VStack(spacing: 0) {
            VStack{
                VStack(alignment: .leading){
                    Text("TEAM PROGRESS THIS WEEK")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.white)
                    
                    
                    Text("You are currently on track for \(progressWord)")
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                    
                    HStack { Spacer() }
                    
                }
                .padding(.leading, 35)
                
                VStack{
                    HStack { Spacer() }
                    
                    ProgressBar(progressValue: teamPercentage, text: "\(String(Int(teamPercentage*100.0))) %")
                        .frame(width: 100.0, height: 100.0)
                        .padding(.bottom, 10.0)
                    
                    Spacer()
                        .frame(height: 15)
                }
                .padding(.bottom, 10)
                
                HStack{
                    Text("Send encouragement")
                        .underline()
                        .multilineTextAlignment(.center)
                        .font(.system(size: 15).bold())
                        .padding(.bottom, 4)
                        .foregroundColor(Colors.lightOrangeBackground)
                        .onTapGesture {
                            self.showEncouragementModal = true
                        }
                    
                    Spacer()
                    
                    Text("Send congrats")
                        .underline()
                        .multilineTextAlignment(.center)
                        .font(.system(size: 15).bold())
                        .padding(.bottom, 4)
                        .foregroundColor(Colors.lightOrangeBackground)
                        .onTapGesture {
                            self.showCongratsModal = true
                        }
                }
                .padding(.horizontal, 24)
                .padding(.trailing, 32)
                .padding(.bottom, 5)
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
