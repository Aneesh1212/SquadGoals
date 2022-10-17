//
//  ProfilePage.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct ProfilePage: View {
    
    @StateObject var viewModel : GoalViewModel
    @State var selectedGoal : Goal = Goal(title: "", reason: "", category: "", isPrivate: false, currTargets: [])
    @State var shouldNavigateToGoalDetails = false
    @State var shouldNavigateToWelcome = false
    @State var bottomSheetOpen = false
    @State var navigateToCreateGoal = false
    
    
    var body: some View {
        VStack{
            HStack() {
                Spacer()
                Button(action: {
                    self.shouldNavigateToWelcome = true
                }, label: {
                    Text("Sign out")
                        .font(.system(size:14))
                        .foregroundColor(Colors.darkOrangeForeground)
                        .padding(.trailing, 10)
                        .padding(.top, 60)
                        .padding(.bottom, 5)
                })
            }
            
            Text(viewModel.user.name)
                .multilineTextAlignment(.leading)
                .font(.system(size: 40, weight: .heavy))
                .foregroundColor(Colors.darkOrangeForeground)
            
            Text("Team \(viewModel.user.groupId)")
                .multilineTextAlignment(.leading)
                .font(.system(size: 20, weight: .heavy))
                .padding(.bottom, 75)
                .foregroundColor(Colors.darkOrangeForeground)
            
            VStack {
                NavigationLink(destination: GoalDetailPage(goal: self.selectedGoal, viewModel: self.viewModel), isActive: $shouldNavigateToGoalDetails) { EmptyView() }
                
                NavigationLink(destination: Welcome(), isActive: $shouldNavigateToWelcome) { EmptyView() }
            }
            
            ScrollView {
                ForEach(viewModel.user.goals, id: \.self) { goal in
                    Button(action: {
                        self.selectedGoal = goal
                        self.shouldNavigateToGoalDetails = true
                    }, label: {
                        HStack{
                            VStack(alignment: .leading){
                                Text("\(goal.title)")
                                    .font(.system(size:16, weight: .heavy))
                                    .foregroundColor(Colors.lightOrangeBackground)
                                    .multilineTextAlignment(.leading)
                                Text("\(goal.category)")
                                    .font(.system(size:16))
                                    .foregroundColor(Colors.lightOrangeBackground)
                            }
                            .padding(.leading, 16)
                            .padding(.vertical, 15)
                            Spacer()
                            VStack{
                                Text(">")
                                    .font(.system(size:40))
                                    .foregroundColor(Colors.lightOrangeBackground)
                            }
                            .padding(.trailing, 16)
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(width: 300)
                        .background(Rectangle().fill(Colors.blueGoalHeader).shadow(radius: 3))
                    })
                    Spacer()
                        .frame(height: 50)
                }
                
                
                NavigationLink(destination: CreateGoal(user: self.viewModel.user, isSingleGoal: true), isActive: $navigateToCreateGoal) { EmptyView() }
                
                Button(action: {
                    self.navigateToCreateGoal = true
                }) {
                    Text("Add goal")
                        .foregroundColor(.white)
                        .frame(width: 200, height: 40, alignment: .center)
                        .background(Colors.blueGoalHeader)
                        .cornerRadius(5)
                }
                
                HStack {
                    Spacer()
                }
                
                Spacer()
                
            }
        }
        .background(Colors.lightOrangeBackground)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
