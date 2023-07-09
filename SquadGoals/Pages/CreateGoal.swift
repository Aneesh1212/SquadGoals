//
//  JoinGroup.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//
import SwiftUI
import Foundation

struct CreateGoal: View {
    
    @State var viewModel : GoalViewModel
    @State var isSingleGoal : Bool
    @State private var shouldNavigate = false
    @State private var shouldNavigateSingleGoal = false
    
    @State private var goalTitle: String = ""
    @State private var goalReason: String = "Don't skip this step! It's valuable to write this down, so you can look back when lacking motivation"
    @State private var goalCategory: String = ""
        
    @State private var currTargetTitle : String = ""
    @State private var currTargetFrequency : String = ""
    
    @State private var showNoGoalTitle: Bool = false
    
    let placeholder = "Don't skip this step! It's valuable to write this down, so you can look back when lacking motivation"
    
    var goalReasonView: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Why is this Goal Important to you?")
                .foregroundColor(Colors.lightOrangeBackground)
            TextEditor(
                text: $goalReason
            )
                .font(.system(size: 16))
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
    
    func addGoal() -> Void {
        if (goalTitle == "") {
            self.showNoGoalTitle = true
            return
        }
        viewModel.createGoal(goalTitle: self.goalTitle, goalReason: self.goalReason, goalCategory: self.goalCategory)
        self.shouldNavigate = true
    }
    
    var body: some View {
        VStack(){
            VStack(alignment: .leading) {
                Title(text: "Let's Create Goals!")
                Spacing(height:6)
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
                NavigationLink(destination: GoalAdded(viewModel: self.viewModel, goalTitle: self.goalTitle), isActive: $shouldNavigate) { EmptyView() }
                NavigationLink(destination: MondayPlanning(viewModel: self.viewModel, mode: Mode.initial), isActive: $shouldNavigateSingleGoal) { EmptyView() }
            }
        }
        .padding(.bottom, Styling.mediumUnit)
        .padding(.horizontal, Styling.mediumUnit)
        .background(Colors.background)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            UITextView.appearance().backgroundColor = .clear
        }
        .alert("Goal must have a title", isPresented: $showNoGoalTitle) {
            Button("Retry", role: .cancel) { }
        }
    }
    
}

