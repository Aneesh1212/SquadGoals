//
//  JoinGroup.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//
import SwiftUI
import Foundation

struct CreateGoal: View {
    
    var viewModel = GoalViewModel(user: User(name: "", phoneNumber: "", groupId: "", goals: [], teammates: []))
    @State var user : User
    @State var isSingleGoal : Bool
    @State private var shouldNavigate = false
    @State private var shouldNavigateSingleGoal = false
    
    @State private var goalTitle: String = ""
    @State private var goalReason: String = "Don't skip this step! It's valuable to write this down, so you can look back when lacking motivation"
    @State private var goalCategory: String = ""
    @State private var goalPrivate = false
        
    @State private var currTargetTitle : String = ""
    @State private var currTargetFrequency : String = ""
    
    
    let placeholder = "Don't skip this step! It's valuable to write this down, so you can look back when lacking motivation"
    
    var goalTitleView: some View {
        
        VStack(alignment: .leading, spacing: 2){
            Text("Goal Title")
                .foregroundColor(Colors.lightOrangeBackground)
            TextField(
                "",
                text: $goalTitle
            )
                .font(.system(size: 20))
                .frame(height: 45, alignment: .center)
                .fixedSize(horizontal: false, vertical: false)
                .foregroundColor(.black)
                .padding(.leading, 10)
                .background(Color.white)
                .cornerRadius(10)
                .lineLimit(nil)
            Spacer()
                .frame(height: 15)
        }
    }
    
    var goalReasonView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Why is this Goal Important to you?")
                .foregroundColor(Colors.lightOrangeBackground)
            TextEditor(
                text: $goalReason
            )
                .font(.system(size: 20))
                .frame(height: 90, alignment: .center)
                .fixedSize(horizontal: false, vertical: false)
                .padding(.leading, 10)
                .background(Color.white)
                .cornerRadius(10)
                .foregroundColor(self.goalReason == placeholder ? .gray : .black)
                .onTapGesture {
                    if self.goalReason == placeholder {
                        self.goalReason = ""
                    }
                }
            Spacer()
                .frame(height: 15)
        }
    }
    
    var goalCategoryView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Goal Category")
                .foregroundColor(Colors.lightOrangeBackground)
            TextField(
                "Mental Health, Fitness, Professional",
                text: $goalCategory
            )
                .font(.system(size: 20))
                .frame(height: 45, alignment: .center)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.leading, 10)
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(10)
            Spacer()
                .frame(height: 12)
        }
    }
    
    var goalPrivateView : some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading) {
                Text("Private?")
                    .foregroundColor(Colors.lightOrangeBackground)
                Text("Only your goal category will be visible to teammate")
                    .foregroundColor(Colors.lightOrangeBackground)
                    .font(.system(size: 10))
                    .fixedSize()
            }
            Spacer()
            if #available(iOS 15.0, *) {
                Toggle("", isOn: $goalPrivate)
                    .tint(Colors.lightOrangeBackground)
            } else {
                Toggle("", isOn: $goalPrivate)
            }
        }
        .padding(.bottom, 15)
    }
    
    
    var body: some View {
        VStack(){
            OnboardingTitle(text: "LET'S CREATE GOALS!")
                .padding(.bottom, Styling.smallUnit)
                .fixedSize(horizontal: false, vertical: true)

            Subtitle(text: "What are 1-3 goals that are important and realistic for you?")
                .padding(.bottom, Styling.mediumUnit)
            
            OnboardingTextEntryWithTitle(title: "Goal Title", placeholder: "", value: $goalTitle)
                .padding(.bottom, Styling.smallUnit)
            
            goalReasonView
                .padding(.bottom, Styling.smallUnit)

            OnboardingTextEntryWithTitle(title: "Goal Category", placeholder: "Fitness, Professional, Well Being", value: $goalCategory)
                .padding(.bottom, Styling.mediumUnit)
            
            Subtitle(text: "In a later step, you will add Weekly Tasks")
                .padding(.bottom, Styling.smallUnit)

            OnboardingActionButton(action: {
                viewModel.createGoal(phoneNumber: user.phoneNumber, goalTitle: self.goalTitle, goalReason: self.goalReason, goalCategory: self.goalCategory, goalPrivate: self.goalPrivate)
                self.shouldNavigate = true
            }, text: "ADD GOAL")
            
            VStack {
                NavigationLink(destination: GoalAdded(user: self.user, goalTitle: self.goalTitle), isActive: $shouldNavigate) { EmptyView() }
                NavigationLink(destination: SundayPlanning(user: self.user, viewModel: GoalViewModel(user:self.user), mode: Mode.initial), isActive: $shouldNavigateSingleGoal) { EmptyView() }
            }
            
            Spacer()
            HStack{
                Spacer()
            }
        }
        .padding(.horizontal, 25)
        .background(Colors.darkOrangeForeground)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
}

