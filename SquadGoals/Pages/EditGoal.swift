//
//  JoinGroup.swift
//  Goal2
//
//  Created by Aneesh Agrawal on 12/18/21.
//
import SwiftUI
import Foundation

struct EditGoal: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>

    @State var goalReason: String = ""
    @State var viewModel : GoalViewModel
    @Binding var goal : Goal
    @State private var goalKey : String = ""
    @State private var goalTitle: String = ""
    @State private var goalCategory: String = ""
    @State var navigateBack = false
    
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
                .padding(.leading, 5)
                .background(Color.white)
                .cornerRadius(10)
                .foregroundColor(.black)
            Spacer()
                .frame(height: 15)
        }
    }

    var body: some View {
        VStack(alignment: .leading){
            Title(text: "Edit Goal")
            Spacing(height: Styling.mediumUnit)
            
            VStack(alignment: .leading) { // Need to be <= 10 elements
                Subtitle(text: "Goal Title")
                OnboardingTextEntry(placeholder: "Enter here", value: $goalTitle)
                    .padding(.bottom, Styling.smallUnit)
                
                
                Subtitle(text: "Why is this goal important to you?")
                goalReasonView
                    .padding(.bottom, Styling.smallUnit)
            }
            
            Subtitle(text: "Goal Category")
            OnboardingTextEntry(placeholder: "Enter here", value: $goalCategory)
            
            Filler()

            RedActionButton(text: "Delete Goal", action: {
                viewModel.deleteGoal(goalKey: goal.key)
            })
            BlueActionButton(text: "Save Changes", action: {
                viewModel.editGoal(key: goalKey, goalTitle: goalTitle, goalReason: goalReason, goalCategory: goalCategory)
                self.goal.title = goalTitle
                self.goal.reason = goalReason
                self.goal.category = goalCategory
                self.presentationMode.wrappedValue.dismiss()
            })
        }
        .padding(.bottom, Styling.mediumUnit)
        .padding(.horizontal, Styling.mediumUnit)
        .background(Colors.background)
        .onTapGesture {
            UIApplication.shared.endEditing()
        }
        .onAppear {
            self.viewModel = viewModel
            self.goalKey = goal.key
            self.goalTitle = goal.title
            self.goalReason = goal.reason
            self.goalCategory = goal.category
        }
    }
    
}

