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
    @State var customMessage = "Test"
    
    var body: some View {
        
        let weekPercentage : Float = isReviewing ? 1.0 : Float(viewModel.getDayOfWeek()) / 7.0
        let teamPercentage : Float = viewModel.calculateTeamTargetPercent()
        let progressString = isReviewing ? getFinishedProgressString(teamPercentage: teamPercentage) : getCurrentProgressString(teamPercentage: teamPercentage, weekPercentage: weekPercentage)
        
        VStack(spacing: 0) {
            VStack{
                VStack(alignment: .leading){
                    Text("TEAM PROGRESS THIS WEEK")
                        .padding(.top, 20)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 30, weight: .heavy))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Text(progressString)
                        .multilineTextAlignment(.leading)
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack { Spacer() }
                    
                }
                .padding(.horizontal, 25)
                
                VStack{
                    HStack { Spacer() }
                    
                    ProgressBar(progressValue: teamPercentage, weekPercentage: weekPercentage, text: "\(String(Int(teamPercentage*100.0))) %")
                        .frame(width: 100.0, height: 100.0)
                        .padding(.bottom, 10.0)
                    
                    Spacer()
                        .frame(height: 15)
                }
                .padding(.bottom, 10)
                
                HStack(spacing: 0) {
                    VStack {
                        Text("Message Squad")
                            .font(.system(size: 16).bold())
                            .foregroundColor(Colors.lightOrangeBackground)
                            .padding(.vertical, 8)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .border(.white, width: 1.5)
                    .onTapGesture {
                        self.showEncouragementModal = true
                    }
                    
                    VStack {
                        Text("Message Teammate")
                            .font(.system(size: 16).bold())
                            .foregroundColor(Colors.lightOrangeBackground)
                            .padding(.vertical, 8)
                    }
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .border(.white, width: 1.5)
                    .onTapGesture {
                        self.showCongratsModal = true
                    }
                }
            }
            .background(Colors.darkOrangeForeground)
            
            TextEditor(
                text: $customMessage
            )
            .font(.system(size: 20))
            .frame(height: 90, alignment: .center)
            .fixedSize(horizontal: false, vertical: false)
            .background(Color.white)
            .cornerRadius(10)
            .foregroundColor(.black)
            
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
                                    ProgressBar(progressValue: teammatePercentage, weekPercentage: weekPercentage, text: teammate.name)
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
                .background(BackgroundClearView())

        })
        .sheet(isPresented: $showCongratsModal, onDismiss: {}, content: {
            CongratsModal(viewModel: self.viewModel, showModal: $showCongratsModal)
                .background(BackgroundClearView())
        })
        .background(Colors.lightOrangeBackground)
    }
}

struct BackgroundClearView: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        DispatchQueue.main.async {
            view.superview?.backgroundColor = .clear
            view.backgroundColor = .clear
            view.superview?.superview?.backgroundColor = .clear
            view.superview?.superview?.superview?.backgroundColor = .clear
            view.superview?.superview?.superview?.superview?.backgroundColor = .clear

        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            uiView.superview?.backgroundColor = .clear
            uiView.backgroundColor = .clear
            uiView.superview?.superview?.backgroundColor = .clear
            uiView.superview?.superview?.superview?.backgroundColor = .clear
            uiView.superview?.superview?.superview?.superview?.backgroundColor = .clear
        }
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
