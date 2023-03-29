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
    
    func addGoal() -> Void {
        // viewModel.createGoal(phoneNumber: user.phoneNumber, goalTitle: self.goalTitle, goalReason: self.goalReason, goalCategory: self.goalCategory, goalPrivate: self.goalPrivate)
        self.shouldNavigate = true
    }
    
    var body: some View {
        VStack(){
            VStack(alignment: .leading) {
                Title(text: "Let's Create Goals!")
                Subtitle(text: "What are 1-3 goals that are important and realistic for you?")
                
                Spacing(height: Styling.mediumUnit)
                
                Subtitle(text: "Goal Title")
                OnboardingTextEntry(placeholder: "Enter here", value: $goalTitle)
                    .padding(.bottom, Styling.smallUnit)
                
                
                Subtitle(text: "Why is this goal important to you?")
                goalReasonView
                    .padding(.bottom, Styling.smallUnit)
                
                Subtitle(text: "Goal Category")
                OnboardingTextEntry(placeholder: "Enter here", value: $goalCategory)
            }
            
            Filler()
            
            Subtitle(text: "In a later step, you will add Weekly Tasks")
            BlueActionButton(text: "Add Goal", action: addGoal)
            
            VStack {
                NavigationLink(destination: GoalAdded(user: self.user, goalTitle: self.goalTitle), isActive: $shouldNavigate) { EmptyView() }
                NavigationLink(destination: MondayPlanning(user: self.user, viewModel: GoalViewModel(user:self.user), mode: Mode.initial), isActive: $shouldNavigateSingleGoal) { EmptyView() }
            }
        }
        .padding(.horizontal, 25)
        .background(Colors.background)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
    }
    
}

