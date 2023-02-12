//
//  ProfilePage.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/27/21.
//

import Foundation
import SwiftUI

struct ProfilePage: View {
    
    @EnvironmentObject var viewModel : GoalViewModel
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
                    // SIGN OUT FUNCTIONALITY
                    self.shouldNavigateToWelcome = true
                }, label: {
                    Text("Sign out")
                        .font(.system(size:14))
                        .foregroundColor(Colors.darkOrangeForeground)
                        .padding(.trailing, Styling.mediumUnit)
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
                NavigationLink(destination: GoalDetailPage(goal: self.selectedGoal), isActive: $shouldNavigateToGoalDetails) { EmptyView() }
                NavigationLink(destination: Welcome(shouldTryToSignIn: false), isActive: $shouldNavigateToWelcome) { EmptyView() }
                NavigationLink(destination: CreateGoal(user: self.viewModel.user, isSingleGoal: true), isActive: $navigateToCreateGoal) { EmptyView() }
            }
            
            VStack{
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
                                .padding(.leading, Styling.smallUnit)
                                .padding(.vertical, Styling.smallUnit)
                                Spacer()
                                VStack{
                                    Text(">")
                                        .font(.system(size:40))
                                        .foregroundColor(Colors.lightOrangeBackground)
                                }
                                .padding(.trailing, Styling.smallUnit)
                            }
                            .fixedSize(horizontal: false, vertical: true)
                            .frame(width: 300)
                            .background(Rectangle().fill(Colors.blueGoalHeader).shadow(radius: 3))
                        })
                        Spacer()
                            .frame(height: 50)
                    }
                    
                    Button(action: {
                        self.navigateToCreateGoal = true
                    }) {
                        Text("Add goal")
                            .foregroundColor(.white)
                            .frame(width: 200, height: 40, alignment: .center)
                            .background(Colors.blueGoalHeader)
                            .cornerRadius(5)
                    }
                }
            }
            
            Spacer()
        }
        .background(Colors.lightOrangeBackground)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
    }
}
